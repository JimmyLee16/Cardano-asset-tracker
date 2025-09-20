<#
PowerShell One-Click Cardano-Address Flow (Fixed)
- Generates or uses an existing mnemonic (phrase.prv)
- Derives root, payment and stake keys (uses chain code for derivation then exports public keys without chain code)
- Builds payment address (payment.addr), stake address (stake.addr) and delegated/base address (addr.delegated)
- Uses the cardano-address executable in the same folder (.\cardano-address or .\cardano-address.exe)

USAGE:
- Place this script in the same folder as your cardano-address executable.
- Run PowerShell and execute: .\manual.ps1
- The script will prompt minimal inputs (generate or use existing mnemonic, network choice, optional passphrase).
- IMPORTANT: This script writes private keys to disk in the current folder. Handle them securely and delete when done.
#>
param(
    [switch]$ForceGenerate,      # if present, always generate a new mnemonic
    [switch]$UseTestnet          # if present, use testnet; otherwise mainnet
)

# Ensure working dir = folder containing this script/exe
try {
    $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
    if ($scriptPath) { Set-Location -Path $scriptPath }
} catch { }

function Prompt-YesNo($msg, $defaultYes=$true) {
    $choice = Read-Host "$msg [Y/N]"
    if ([string]::IsNullOrWhiteSpace($choice)) { return $defaultYes }
    return $choice.Trim().ToUpper().StartsWith('Y')
}

Write-Host "=== Cardano-Address One-Click Flow (PowerShell) ===" -ForegroundColor Cyan

# Locate cardano-address executable
$exePaths = @(".\cardano-address.exe", ".\cardano-address")
$cardanoExe = $null
foreach ($p in $exePaths) {
    if (Test-Path $p) { $cardanoExe = $p; break }
}
if (-not $cardanoExe) {
    Write-Error "cardano-address executable not found in current folder. Place cardano-address.exe or cardano-address next to this script."
    exit 1
} else {
    Write-Host "Found cardano-address executable: $cardanoExe"
}

# Network tag
if ($UseTestnet) {
    $networkTag = "testnet"
} else {
    $isTest = Prompt-YesNo "Use testnet? (default No = mainnet)" $false
    $networkTag = if ($isTest) { "testnet" } else { "mainnet" }
}
Write-Host "Selected network: $networkTag`n"

# Mnemonic: generate or use existing phrase.prv
$phraseFile = ".\phrase.prv"
$mnemonic   = $null   # giữ mnemonic manual trong RAM

if (-not $ForceGenerate -and (Test-Path $phraseFile)) {
    $useExisting = Prompt-YesNo "phrase.prv exists. Use existing file? (No = generate new)" $true
    if (-not $useExisting) { $ForceGenerate = $true }
}

if ($ForceGenerate -or -not (Test-Path $phraseFile)) {
    Write-Host "Chọn cách khởi tạo mnemonic:"
    Write-Host "  manual - nhập mnemonic thủ công"
    Write-Host "  auto   - generate mnemonic mới"
    Write-Host "  file   - dùng file có sẵn khác"
    $choice = Read-Host "Nhập lựa chọn (manual/auto/file)"

    switch ($choice) {
        "manual" {
            $mnemonic = Read-Host "Nhập mnemonic (cách nhau bằng dấu cách)"
            Write-Host "Mnemonic đã được nhập (chỉ giữ trong biến, không lưu file)."
        }
        "auto" {
            $size = Read-Host "Nhập số lượng word muốn tạo (9,12,15,21,24)"
            Write-Host "Generating mnemonic và lưu vào $phraseFile..."
            & $cardanoExe recovery-phrase generate --size $size | Out-File -FilePath $phraseFile -Encoding utf8 -NoNewline
            if ($LASTEXITCODE -ne 0) { Write-Error "Failed to generate mnemonic. Aborting."; exit 2 }
            Write-Host "Mnemonic saved to $phraseFile"
        }
        "file" {
            $srcFile = Read-Host "Nhập đường dẫn file mnemonic có sẵn"
            if (Test-Path $srcFile) {
                Get-Content $srcFile -Raw | Out-File -FilePath $phraseFile -Encoding utf8 -NoNewline
                Write-Host "Copied mnemonic từ $srcFile -> $phraseFile"
            } else {
                Write-Error "File không tồn tại: $srcFile"
                exit 3
            }
        }
        default {
            Write-Error "Lựa chọn không hợp lệ. Aborting."
            exit 1
        }
    }
}
else {
    Write-Host "Using existing $phraseFile"
}

# Prompt for optional passphrase (can be empty)
Write-Host "`nIf you want an empty passphrase press Enter. Otherwise type a passphrase (it will not be saved to disk)."
$securePass = Read-Host "Enter passphrase (hidden)" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePass)
try { $passPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($BSTR) }
finally { [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR) }

# Create root.xsk
Write-Host "`nCreating root.xsk (extended, WITH chain code for derivation)..."
if ($mnemonic) { $phraseContent = $mnemonic.Trim() }
else { $phraseContent = Get-Content $phraseFile -Raw }

$inputForRoot = $phraseContent + "`n" + $passPlain
$inputForRoot | & $cardanoExe key from-recovery-phrase Shelley > .\root.xsk
if ($LASTEXITCODE -ne 0) { Write-Error "Failed to create root.xsk. Aborting."; exit 3 }
Write-Host "root.xsk created."

# ===== Derive payment key =====
$null = Read-Host "`nNhấn Enter để bắt đầu derive Payment key"
$payIndex = Read-Host "Nhập chỉ số index cho payment key (0 -> 2^31-1)"
$payPath = "1852H/1815H/0H/0/$payIndex"
Write-Host "Deriving payment private key -> addr.xsk (path: $payPath)"
Get-Content .\root.xsk -Raw | & $cardanoExe key child $payPath > .\addr.xsk
if ($LASTEXITCODE -ne 0) { Write-Error "Failed to derive addr.xsk"; exit 4 }
Write-Host "Exporting payment public key (non-extended) -> addr.xvk"
Get-Content .\addr.xsk -Raw | & $cardanoExe key public --without-chain-code > .\addr.xvk
if ($LASTEXITCODE -ne 0) { Write-Error "Failed to export addr.xvk"; exit 5 }
Write-Host "Building payment.addr"
Get-Content .\addr.xvk -Raw | & $cardanoExe address payment --network-tag $networkTag > .\payment.addr

# ===== Derive stake key =====
$null = Read-Host "`nNhấn Enter để bắt đầu derive Stake key"
$stakeIndex = Read-Host "Nhập chỉ số index cho stake key (0 -> 2^31-1)"
$stakePath = "1852H/1815H/0H/2/$stakeIndex"
Write-Host "Deriving stake private key -> stake.xsk (path: $stakePath)"
Get-Content .\root.xsk -Raw | & $cardanoExe key child $stakePath > .\stake.xsk
if ($LASTEXITCODE -ne 0) { Write-Error "Failed to derive stake.xsk"; exit 7 }
Write-Host "Exporting stake public key -> stake.xvk"
Get-Content .\stake.xsk -Raw | & $cardanoExe key public --without-chain-code > .\stake.xvk
Write-Host "Building stake.addr"
Get-Content .\stake.xvk -Raw | & $cardanoExe address stake --network-tag $networkTag > .\stake.addr

# ===== Delegated address =====
Write-Host "Building delegated/base address -> addr.delegated"
$stakePub = (Get-Content .\stake.xvk -Raw).Trim()
Get-Content .\payment.addr -Raw | & $cardanoExe address delegation $stakePub > .\addr.delegated

Write-Host "`n=== DONE ===" -ForegroundColor Green
Write-Host "Created:"
Write-Host "  phrase.prv      (mnemonic, nếu dùng auto/file)"
Write-Host "  root.xsk        (root private key - extended)"
Write-Host "  addr.xsk / .xvk (payment key pair)"
Write-Host "  payment.addr    (payment address)"
Write-Host "  stake.xsk / .xvk (stake key pair)"
Write-Host "  stake.addr      (stake address)"
Write-Host "  addr.delegated  (base address with staking)"

# Cleanup
if ($passPlain) { $passPlain = $null; [GC]::Collect(); [GC]::WaitForPendingFinalizers() }
