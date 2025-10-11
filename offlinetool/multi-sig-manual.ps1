<#
manual_multisig.ps1
Offline manual multisig builder using cardano-address (shared keys, 1854H)
- Fully interactive: user chooses names, how many mnemonics to create, indices, active_from/active_until, output filenames.
- Requires: cardano-address (cardano-address.exe) in same folder or in PATH.
- Network default: testnet (you can pass -UseMainnet to use mainnet)
- WARNING: This script writes private-key files to disk. Keep them secure/offline.
#>

param(
    [switch]$UseMainnet
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Info($msg){ Write-Host $msg -ForegroundColor Cyan }
function Write-Warn($msg){ Write-Host $msg -ForegroundColor Yellow }
function Write-Err($msg){ Write-Host $msg -ForegroundColor Red }
function Pause-Continue(){ Read-Host "`nNhấn Enter để tiếp tục..." }

# locate cardano-address executable
$exeCandidates = @(".\cardano-address.exe", ".\cardano-address.exe", ".\cardano-address", "cardano-address")
$cardanoExe = $null
foreach ($c in $exeCandidates) {
    if (Get-Command $c -ErrorAction SilentlyContinue) { $cardanoExe = (Get-Command $c).Path; break }
    if (Test-Path $c) { $cardanoExe = (Resolve-Path $c).Path; break }
}
if (-not $cardanoExe) {
    Write-Err "Không tìm thấy cardano-address executable trong PATH hoặc thư mục hiện tại. Đặt cardano-address(.exe) cạnh script hoặc thêm vào PATH."
    exit 1
}
Write-Info "Found cardano-address: $cardanoExe`n"

# working folders
$keysDir = Join-Path -Path (Get-Location) -ChildPath "keys"
if (-not (Test-Path $keysDir)) { New-Item -ItemType Directory -Path $keysDir | Out-Null }

# network tag
if ($UseMainnet) { $networkTag = "mainnet" } else {
    $useTest = Read-Host "Dùng testnet? (Y = testnet, N = mainnet) [default Y]"
    if ([string]::IsNullOrWhiteSpace($useTest) -or $useTest.Trim().ToUpper().StartsWith("Y")) { $networkTag = "testnet" } else { $networkTag = "mainnet" }
}
Write-Info "Network: $networkTag`n"

function Prompt-YesNo($msg, $defaultYes=$true) {
    $d = if ($defaultYes) { "Y" } else { "N" }
    $r = Read-Host "$msg [Y/N] (default $d)"
    if ([string]::IsNullOrWhiteSpace($r)) { return $defaultYes }
    return $r.Trim().ToUpper().StartsWith('Y')
}

function Ensure-Int($s, $name) {
    if (-not [Int64]::TryParse($s, [ref]$n)) {
        throw "Giá trị $name không hợp lệ (phải là số nguyên)."
    }
    return [int]$n
}

function Create-Mnemonic($name) {
    $sizes = "12,15,24"
    while ($true) {
        $sz = Read-Host "Chọn kích thước mnemonic cho '$name' ($sizes). Enter để dùng 15"
        if ([string]::IsNullOrWhiteSpace($sz)) { $sz = "15" }
        if ($sz -in @("12","15","24")) { break } else { Write-Warn "Chỉ chấp nhận 12,15 hoặc 24" }
    }
    $outFile = Join-Path $keysDir "$name.phrase"
    Write-Info "Tạo mnemonic (size=$sz) và lưu: $outFile"
    & $cardanoExe recovery-phrase generate --size $sz > $outFile
    if ($LASTEXITCODE -ne 0) { throw "Failed to generate mnemonic for $name" }
    Write-Info "Mnemonic saved -> $outFile"
    return $outFile
}

function Input-MnemonicManual($name) {
    $mn = Read-Host "Dán mnemonic (cách nhau bằng space) cho '$name' rồi Enter"
    $outFile = Join-Path $keysDir "$name.phrase"
    Set-Content -Path $outFile -Value $mn -Encoding ascii
    Write-Info "Saved manual mnemonic -> $outFile"
    return $outFile
}

function Derive-Root($name, $phraseFile) {
    $out = Join-Path $keysDir "$name.root.xsk"
    Write-Info "Derive root.xsk for $name -> $out"
    Get-Content $phraseFile -Raw | & $cardanoExe key from-recovery-phrase Shelley > $out
    if ($LASTEXITCODE -ne 0) { throw "Failed deriving root for $name" }
    return $out
}

function Derive-ChildAndXvk($name, $rootFile, $pathIndex) {
    # pathIndex is integer to be appended to 1854H/1815H/0H/0/<index>
    $child = Join-Path $keysDir "$name.pay.$pathIndex.xsk"
    $xvk   = Join-Path $keysDir "$name.pay.$pathIndex.xvk"
    $deriv = "1854H/1815H/0H/0/$pathIndex"
    Write-Info "Derive child ($deriv) -> $child"
    Get-Content $rootFile -Raw | & $cardanoExe key child $deriv > $child
    if ($LASTEXITCODE -ne 0) { throw "Failed deriving child for $name with index $pathIndex" }
    Write-Info "Export public (without chain code) -> $xvk"
    Get-Content $child -Raw | & $cardanoExe key public --without-chain-code > $xvk
    if ($LASTEXITCODE -ne 0) { throw "Failed exporting xvk for $name" }
    return @{ Child = $child; Xvk = $xvk }
}

function Get-KeyHashFromXvk($xvkFile) {
    $out = & $cardanoExe key hash < $xvkFile
    if ($LASTEXITCODE -ne 0) { throw "Failed to compute key hash from $xvkFile" }
    return $out.Trim()
}

function Show-ExistingKeys() {
    $files = Get-ChildItem -Path $keysDir -File | Where-Object { $_.Name -match '\.(phrase|root\.xsk|pay\..*\.xvk|hash)$' } | Sort-Object Name
    if ($files.Count -eq 0) { Write-Host "(No files in keys/)"; return }
    Write-Host "Existing files in keys/:"
    $files | ForEach-Object { Write-Host " - $($_.Name)" }
}

# MAIN INTERACTIVE MENU
while ($true) {
    Clear-Host
    Write-Host "=== Manual multisig builder (shared keys - 1854) ===" -ForegroundColor Green
    Write-Host "Working folder: $(Get-Location)"
    Write-Host "Keys folder: $keysDir"
    Write-Host ""
    Write-Host "Menu:"
    Write-Host " 1) Tạo hoặc nhập mnemonic (participant)"
    Write-Host " 2) Derive root.xsk từ mnemonic"
    Write-Host " 3) Derive payment key (1854H shared) và export xvk"
    Write-Host " 4) Tính key-hash từ xvk (và lưu)"
    Write-Host " 5) Xem danh sách keys hiện có"
    Write-Host " 6) Build multisig policy & address (manual, includes active_from/active_until)"
    Write-Host " 7) Exit"
    $opt = Read-Host "Chọn bước (1-7)"
    switch ($opt) {
        '1' {
            $name = Read-Host "Đặt tên participant (ví dụ alice) (không có space)"
            if ([string]::IsNullOrWhiteSpace($name)) { Write-Warn "Tên không hợp lệ"; Pause-Continue; continue }
            $choice = Read-Host "Tạo mới (G) hay nhập thủ công (I)? [G/I] (default G)"
            if ([string]::IsNullOrWhiteSpace($choice) -or $choice.Trim().ToUpper().StartsWith('G')) {
                try { Create-Mnemonic $name } catch { Write-Err $_.Exception.Message }
            } else {
                try { Input-MnemonicManual $name } catch { Write-Err $_.Exception.Message }
            }
            Pause-Continue
        }
        '2' {
            Show-ExistingKeys
            $name = Read-Host "Nhập tên participant để derive root (vd: alice)"
            $phraseFile = Join-Path $keysDir "$name.phrase"
            if (-not (Test-Path $phraseFile)) { Write-Warn "Không tìm thấy $phraseFile"; Pause-Continue; continue }
            try { Derive-Root $name $phraseFile; Write-Info "root.xsk saved for $name" } catch { Write-Err $_.Exception.Message }
            Pause-Continue
        }
        '3' {
            Show-ExistingKeys
            $name = Read-Host "Nhập tên participant để derive payment key (vd: alice)"
            $rootFile = Join-Path $keysDir "$name.root.xsk"
            if (-not (Test-Path $rootFile)) { Write-Warn "Không tìm thấy $rootFile. Hãy chạy bước 2 trước."; Pause-Continue; continue }
            $idxRaw = Read-Host "Nhập index cho payment child (số nguyên 0..2147483647). Enter=0"
            if ([string]::IsNullOrWhiteSpace($idxRaw)) { $idxRaw = "0" }
            try { $idx = Ensure-Int $idxRaw "index" } catch { Write-Err $_; Pause-Continue; continue }
            try {
                $res = Derive-ChildAndXvk $name $rootFile $idx
                Write-Info "Child xsk: $($res.Child)"
                Write-Info "Public xvk: $($res.Xvk)"
            } catch { Write-Err $_.Exception.Message }
            Pause-Continue
        }
        '4' {
            Show-ExistingKeys
            $xvkFile = Read-Host "Nhập đường dẫn tới .xvk (ví dụ keys/alice.pay.0.xvk) hoặc tên participant (alice)"
            if ($xvkFile -and -not (Test-Path $xvkFile)) {
                # if provided just name
                $maybe = Join-Path $keysDir "$xvkFile.pay.0.xvk"
                if (Test-Path $maybe) { $xvkFile = $maybe } else {
                    # try general match
                    $matches = Get-ChildItem $keysDir -Filter "$xvkFile*.xvk" -File -ErrorAction SilentlyContinue
                    if ($matches.Count -eq 1) { $xvkFile = $matches[0].FullName } elseif ($matches.Count -gt 1) {
                        Write-Host "Tìm được nhiều file:"
                        $matches | ForEach-Object { Write-Host " - $($_.Name)" }
                        $xvkFile = Read-Host "Gõ đường dẫn đầy đủ tới xvk bạn muốn dùng"
                    } else {
                        Write-Warn "Không tìm thấy xvk cho '$xvkFile'"; Pause-Continue; continue
                    }
                }
            }
            if (-not (Test-Path $xvkFile)) { Write-Warn "Không tìm thấy file xvk: $xvkFile"; Pause-Continue; continue }
            try {
                $hash = Get-KeyHashFromXvk $xvkFile
                Write-Info "Key hash: $hash"
                $save = Read-Host "Lưu hash vào file? Nhập tên file (Enter để skip). Ví dụ alice.hash"
                if (-not [string]::IsNullOrWhiteSpace($save)) {
                    $outf = Join-Path $keysDir $save
                    Set-Content -Path $outf -Value $hash -Encoding ascii
                    Write-Info "Saved -> $outf"
                }
            } catch { Write-Err $_.Exception.Message }
            Pause-Continue
        }
        '5' {
            Show-ExistingKeys
            Pause-Continue
        }
        '6' {
            # Build multisig policy & address (manual)
            Write-Host "`n=== Build multisig policy & address ===" -ForegroundColor Green
            $Mraw = Read-Host "Nhập tổng số participant M (ví dụ 3)"
            try { $M = Ensure-Int $Mraw "M" } catch { Write-Err $_; Pause-Continue; continue }
            $Nraw = Read-Host "Nhập threshold N (số ký tối thiểu, ≤ M)"
            try { $N = Ensure-Int $Nraw "N" } catch { Write-Err $_; Pause-Continue; continue }
            if ($N -lt 1 -or $N -gt $M) { Write-Err "N phải ≥1 và ≤ M"; Pause-Continue; continue }

            $hashes = @()
            for ($i=1; $i -le $M; $i++) {
                Write-Host "`nParticipant #$i"
                $choice = Read-Host "Bạn muốn (1) chọn từ keys/*.hash hoặc (2) tính từ xvk hiện có hoặc (3) nhập thủ công? [1/2/3] (default 2)"
                if ([string]::IsNullOrWhiteSpace($choice)) { $choice = "2" }
                switch ($choice.Trim()) {
                    '1' {
                        $list = Get-ChildItem $keysDir -Filter "*.hash" -File -ErrorAction SilentlyContinue
                        if ($list.Count -eq 0) { Write-Warn "Không có .hash trong keys/"; $i--; continue }
                        Write-Host "Available .hash files:"
                        $list | ForEach-Object { Write-Host " - $($_.Name)" }
                        $sel = Read-Host "Nhập tên file .hash (ví dụ alice.hash)"
                        $hf = Join-Path $keysDir $sel
                        if (-not (Test-Path $hf)) { Write-Warn "File không tồn tại"; $i--; continue }
                        $h = (Get-Content $hf -Raw).Trim()
                        $hashes += $h
                    }
                    '3' {
                        $h = Read-Host "Dán key hash (hex) cho participant #$i"
                        if ([string]::IsNullOrWhiteSpace($h)) { Write-Warn "Empty"; $i--; continue }
                        $hashes += $h.Trim()
                    }
                    default {
                        # option 2: compute from xvk
                        $xvks = Get-ChildItem $keysDir -Filter "*.xvk" -File -ErrorAction SilentlyContinue
                        if ($xvks.Count -gt 0) {
                            Write-Host "Available xvk files:"
                            $xvks | ForEach-Object { Write-Host " - $($_.Name)" }
                        } else { Write-Warn "Không có xvk trong keys/"; }
                        $xvkSel = Read-Host "Nhập đường dẫn tới .xvk (hoặc tên participant như alice.pay.0.xvk)"
                        if (-not (Test-Path $xvkSel)) {
                            # try relative in keys
                            $maybe = Join-Path $keysDir $xvkSel
                            if (Test-Path $maybe) { $xvkSel = $maybe } else {
                                $matches = Get-ChildItem $keysDir -Filter "$xvkSel*.xvk" -File -ErrorAction SilentlyContinue
                                if ($matches.Count -eq 1) { $xvkSel = $matches[0].FullName } elseif ($matches.Count -gt 1) {
                                    Write-Host "Tìm thấy nhiều file:"
                                    $matches | ForEach-Object { Write-Host " - $($_.Name)" }
                                    $xvkSel = Read-Host "Gõ đường dẫn đầy đủ tới xvk"
                                } else { Write-Warn "Không tìm thấy $xvkSel"; $i--; continue }
                            }
                        }
                        try {
                            $h = Get-KeyHashFromXvk $xvkSel
                            Write-Info "Key hash = $h"
                            $save = Read-Host "Lưu hash này vào file? (nhập tên file, Enter để skip)"
                            if (-not [string]::IsNullOrWhiteSpace($save)) {
                                $hf = Join-Path $keysDir $save
                                Set-Content -Path $hf -Value $h -Encoding ascii
                                Write-Info "Saved -> $hf"
                            }
                            $hashes += $h
                        } catch { Write-Err $_.Exception.Message; $i--; continue }
                    }
                }
            } # end for participants

            # optional active_from / active_until
            $activeFrom = Read-Host "Nhập active_from slot (Enter để bỏ qua)"
            if (-not [string]::IsNullOrWhiteSpace($activeFrom)) { try { $activeFrom = Ensure-Int $activeFrom "active_from" } catch { Write-Err $_; Pause-Continue; continue } }
            $activeUntil = Read-Host "Nhập active_until slot (Enter để bỏ qua)"
            if (-not [string]::IsNullOrWhiteSpace($activeUntil)) { try { $activeUntil = Ensure-Int $activeUntil "active_until" } catch { Write-Err $_; Pause-Continue; continue } }

            # build expression string
            $sigParts = $hashes | ForEach-Object { "sig $_" }
            $sigList = $sigParts -join ", "
            $atLeastExpr = "at_least $N [ $sigList ]"
            if ($null -ne $activeFrom -or $null -ne $activeUntil) {
                $innerParts = @()
                $innerParts += $atLeastExpr
                if ($null -ne $activeFrom) { $innerParts += "active_from $activeFrom" }
                if ($null -ne $activeUntil) { $innerParts += "active_until $activeUntil" }
                $expr = "all [ " + ($innerParts -join ", ") + " ]"
            } else {
                $expr = $atLeastExpr
            }

            Write-Host "`nFinal policy expression:`n$expr`n"

            $savePolicyName = Read-Host "Nhập tên file để lưu policy string (ví dụ policy_2of3.txt) (Enter để skip saving)"
            if (-not [string]::IsNullOrWhiteSpace($savePolicyName)) {
                $pf = Join-Path $keysDir $savePolicyName
                Set-Content -Path $pf -Value $expr -Encoding ascii
                Write-Info "Saved policy expression -> $pf"
            }

            # call cardano-address to get policy id (address policy)
            Write-Info "Generating policy id via cardano-address..."
            $policyId = & $cardanoExe address policy --script $expr
            if ($LASTEXITCODE -ne 0) { Write-Err "Failed to build policy id"; Pause-Continue; continue }
            $policyId = $policyId.Trim()
            Write-Info "Policy ID: $policyId"

            $savePolicyId = Read-Host "Lưu policy id vào file (ví dụ policy_id.txt)? Enter để skip"
            if (-not [string]::IsNullOrWhiteSpace($savePolicyId)) {
                $outp = Join-Path $keysDir $savePolicyId
                Set-Content -Path $outp -Value $policyId -Encoding ascii
                Write-Info "Saved -> $outp"
            }

            # Build multisig payment address
            Write-Info "Building multisig payment address..."
            $addrOut = & $cardanoExe address payment --network-tag $networkTag --script $expr
            if ($LASTEXITCODE -ne 0) { Write-Err "Failed to build multisig address"; Pause-Continue; continue }
            $addrOut = $addrOut.Trim()
            Write-Host "`nMultisig payment address:`n$addrOut`n"
            $addrFile = Read-Host "Tên file lưu address (ví dụ multisig.addr) (Enter để use multisig.addr)"
            if ([string]::IsNullOrWhiteSpace($addrFile)) { $addrFile = "multisig.addr" }
            $addrPath = Join-Path $keysDir $addrFile
            Set-Content -Path $addrPath -Value $addrOut -Encoding ascii
            Write-Info "Saved address -> $addrPath"

            Pause-Continue
        }
        '7' {
            Write-Host "Exit."
            break
        }
        default {
            Write-Warn "Lựa chọn không hợp lệ"
            Pause-Continue
        }
    } # switch
} # while
