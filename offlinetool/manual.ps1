<#
PowerShell One-Click Cardano-Address Flow (Fixed)
- Generates or uses an existing 15-word mnemonic (phrase.prv)
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

if (-not $ForceGenerate -and (Test-Path $phraseFile)) {
    $useExisting = Prompt-YesNo "phrase.prv exists. Use existing file? (No = generate new)" $true
    if (-not $useExisting) { $ForceGenerate = $true }
}

if ($ForceGenerate -or -not (Test-Path $phraseFile)) {
    Write-Host "Chọn cách khởi tạo mnemonic:"
    Write-Host "  1) manual - nhập mnemonic thủ công"
    Write-Host "  2) auto   - generate mnemonic mới"
    Write-Host "  3) file   - dùng file có sẵn khác"
    $choice = Read-Host "Nhập lựa chọn (manual/auto/file)"

    switch ($choice) {
        "manual" {
            $mnemonic = Read-Host "Nhập mnemonic (cách nhau bằng dấu cách)"
            [System.IO.File]::WriteAllText($phraseFile, $mnemonic, [System.Text.Encoding]::UTF8)
            Write-Host "Mnemonic đã được lưu vào $phraseFile"
        }
        "auto" {
            $size = Read-Host "Nhập số lượng word muốn tạo (9,12,15,21,24)"
            Write-Host "Generating mnemonic và lưu vào $phraseFile..."
            & $cardanoExe recovery-phrase generate --size $size > $phraseFile
            if ($LASTEXITCODE -ne 0) {
                Write-Error "Failed to generate mnemonic. Aborting."
                exit 2
            }
            Write-Host "Mnemonic saved to $phraseFile"
        }
        "file" {
            $srcFile = Read-Host "Nhập đường dẫn file mnemonic có sẵn"
            if (Test-Path $srcFile) {
                Copy-Item $srcFile $phraseFile -Force
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
# Convert SecureString to plain text in memory
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePass)
try {
    $passPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($BSTR)
} finally {
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
}
# Note: $passPlain contains passphrase (possibly empty). Avoid writing it to disk.

# Create root.xsk (KEEP chain code for derivation)
Write-Host "`nCreating root.xsk (extended, WITH chain code for derivation)..."
$phraseContent = Get-Content .\phrase.prv -Raw
$inputForRoot = $phraseContent + "`n" + $passPlain
$inputForRoot | & $cardanoExe key from-recovery-phrase Shelley > .\root.xsk
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to create root.xsk. Aborting."
    exit 3
}
Write-Host "root.xsk created."

# ===== Derive payment key (interactive index) =====
$null = Read-Host "`nNhấn Enter để bắt đầu derive Payment key"
$payIndex = Read-Host "Nhập chỉ số index cho payment key (bạn có thể nhập số từ 0 -> 2^31-1)"
$payPath = "1852H/1815H/0H/0/$payIndex"
Write-Host "Deriving payment private key -> addr.xsk (path: $payPath)"
Get-Content .\root.xsk -Raw | & $cardanoExe key child $payPath > .\addr.xsk
if ($LASTEXITCODE -ne 0) { Write-Error "Failed to derive addr.xsk"; exit 4 }
Write-Host "Exporting payment public key (non-extended) -> addr.xvk"
Get-Content .\addr.xsk -Raw | & $cardanoExe key public --without-chain-code > .\addr.xvk
if ($LASTEXITCODE -ne 0) { Write-Error "Failed to export addr.xvk"; exit 5 }

# Build payment.addr from addr.xvk
Write-Host "Building payment.addr from addr.xvk -> payment.addr"
Get-Content .\addr.xvk -Raw | & $cardanoExe address payment --network-tag $networkTag > .\payment.addr
if ($LASTEXITCODE -ne 0) { Write-Error "Failed to build payment.addr"; exit 6 }
Write-Host "payment.addr created."

# ===== Derive stake key (interactive index) =====
$null = Read-Host "`nNhấn Enter để bắt đầu derive Stake key"
$stakeIndex = Read-Host "Nhập chỉ số index cho stake key (bạn có thể nhập số từ 0 -> 2^31-1)"
$stakePath = "1852H/1815H/0H/2/$stakeIndex"
Write-Host "Deriving stake private key -> stake.xsk (path: $stakePath)"
Get-Content .\root.xsk -Raw | & $cardanoExe key child $stakePath > .\stake.xsk
if ($LASTEXITCODE -ne 0) { Write-Error "Failed to derive stake.xsk"; exit 7 }
Write-Host "Exporting stake public key (non-extended) -> stake.xvk"
Get-Content .\stake.xsk -Raw | & $cardanoExe key public --without-chain-code > .\stake.xvk
if ($LASTEXITCODE -ne 0) { Write-Error "Failed to export stake.xvk"; exit 8 }

# (Optional) Build stake.addr for registration / viewing
Write-Host "Building stake.addr -> stake.addr"
Get-Content .\stake.xvk -Raw | & $cardanoExe address stake --network-tag $networkTag > .\stake.addr
if ($LASTEXITCODE -ne 0) { Write-Warning "Failed to build stake.addr (non-fatal)"; } else { Write-Host "stake.addr created." }

# Build delegated/base address by piping payment.addr and passing stake.xvk as credential
Write-Host "Building delegated/base address -> addr.delegated"
$stakePub = (Get-Content .\stake.xvk -Raw).Trim()
if (-not $stakePub) { Write-Error "stake.xvk is empty; cannot build delegated address"; exit 9 }
Get-Content .\payment.addr -Raw | & $cardanoExe address delegation $stakePub  > .\addr.delegated
if ($LASTEXITCODE -ne 0) { Write-Error "Failed to build addr.delegated"; exit 10 }
Write-Host "addr.delegated created."

# Final info and cleanup
Write-Host "`n=== DONE ===" -ForegroundColor Green
Write-Host "Files created in current folder:"
Write-Host "  phrase.prv      (mnemonic)"
Write-Host "  root.xsk        (root private key - extended for derivation)"
Write-Host "  addr.xsk        (payment private key - child)"
Write-Host "  addr.xvk        (payment public key - non-extended)"
Write-Host "  payment.addr    (payment address)"
Write-Host "  stake.xsk       (stake private key - child)"
Write-Host "  stake.xvk       (stake public key - non-extended)"
Write-Host "  stake.addr      (stake address)"
Write-Host "  addr.delegated  (delegated/base address with staking)"

# Zero out passphrase variable for safety
if ($passPlain) {
    $passPlain = $null
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
}

Write-Host "`nSecurity notes:"
Write-Host " - These files contain private keys. Keep them safe and offline."
Write-Host " - If you used a passphrase, it is not saved to disk, but it was in memory during operations."
Write-Host " - Remove temporary or sensitive files after use."


