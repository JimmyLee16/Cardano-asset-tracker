# Midnight Scavenger Checker (Auto UTF-8 BOM)

# --- AUTO FIX UTF-8 ENCODING WITH BOM (for PowerShell 5.1 GUI) ---

$path = $MyInvocation.MyCommand.Definition
$bytes = [System.IO.File]::ReadAllBytes($path)

# Kiểm tra 3 byte đầu có phải EF BB BF (BOM) không
if ($bytes.Length -lt 3 -or $bytes[0] -ne 0xEF -or $bytes[1] -ne 0xBB -or $bytes[2] -ne 0xBF) {
    Write-Host "⚙️  Đang tự chuyển file sang UTF-8 with BOM để hiển thị tiếng Việt đúng..." -ForegroundColor Yellow
    
    # Đọc toàn bộ nội dung hiện tại
    $content = Get-Content -Raw -Path $path
    
    # Ghi lại bằng UTF8 with BOM
    $utf8bom = New-Object System.Text.UTF8Encoding($true)
    [System.IO.File]::WriteAllText($path, $content, $utf8bom)

    Write-Host "✅ Đã chuyển sang UTF-8 with BOM, khởi động lại..." -ForegroundColor Green
    # Tự khởi chạy lại chính nó
    Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -NoProfile -File `"$path`""
    exit
}

# --- Đặt encoding cho console để đảm bảo không lỗi font ---
chcp 65001 | Out-Null
[Console]::InputEncoding  = [Text.Encoding]::UTF8
[Console]::OutputEncoding = [Text.Encoding]::UTF8
$OutputEncoding           = [Text.Encoding]::UTF8

# --- (phần code GUI của bạn tiếp tục ở đây) ---
Write-Host "🚀 Khởi tạo giao diện Midnight Scavenger..." -ForegroundColor Cyan



Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --------- MÀU & FONT CHỦ ĐỀ ------------
$primaryColor   = [System.Drawing.Color]::FromArgb(0, 120, 215)
$bgColor        = [System.Drawing.Color]::FromArgb(245, 247, 250)
$panelColor     = [System.Drawing.Color]::FromArgb(255, 255, 255)
$textColor      = [System.Drawing.Color]::FromArgb(45, 45, 48)
$accentColor    = [System.Drawing.Color]::FromArgb(0, 153, 188)
$fontMain       = New-Object System.Drawing.Font("Segoe UI", 10)

# --------- FORM CHÍNH ------------
$form = New-Object System.Windows.Forms.Form
$form.Text = "💠 Midnight Scavenger Checker"
$form.Size = New-Object System.Drawing.Size(720, 650)
$form.StartPosition = "CenterScreen"
$form.BackColor = $bgColor
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false

# --------- TIÊU ĐỀ ------------
$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "Crypto Receipts Checker"
$lblTitle.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 18)
$lblTitle.ForeColor = $textColor
$lblTitle.TextAlign = 'MiddleCenter'
$lblTitle.Size = New-Object System.Drawing.Size(700, 40)
$lblTitle.Location = New-Object System.Drawing.Point(10, 20)
$form.Controls.Add($lblTitle)

# --------- PANEL CSV DROP ------------
$panelDrop = New-Object System.Windows.Forms.Panel
$panelDrop.Size = New-Object System.Drawing.Size(620, 160)
$panelDrop.Location = New-Object System.Drawing.Point(50, 80)
$panelDrop.BackColor = $panelColor
$panelDrop.BorderStyle = 'FixedSingle'
$panelDrop.AllowDrop = $true
$form.Controls.Add($panelDrop)

$lblIcon = New-Object System.Windows.Forms.Label
$lblIcon.Text = "📂"
$lblIcon.Font = New-Object System.Drawing.Font("Segoe UI Emoji", 52)
$lblIcon.Location = New-Object System.Drawing.Point(265, 10)
$lblIcon.Size = New-Object System.Drawing.Size(90, 80)
$lblIcon.TextAlign = 'MiddleCenter'
$panelDrop.Controls.Add($lblIcon)

$lblDrop = New-Object System.Windows.Forms.Label
$lblDrop.Text = "Kéo/thả file CSV vào đây hoặc click để chọn"
$lblDrop.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$lblDrop.ForeColor = [System.Drawing.Color]::Gray
$lblDrop.TextAlign = 'MiddleCenter'
$lblDrop.Size = New-Object System.Drawing.Size(620, 40)
$lblDrop.Location = New-Object System.Drawing.Point(0, 100)
$panelDrop.Controls.Add($lblDrop)

# --------- LABEL FILE INFO ------------
$lblFileInfo = New-Object System.Windows.Forms.Label
$lblFileInfo.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 10)
$lblFileInfo.ForeColor = $accentColor
$lblFileInfo.Size = New-Object System.Drawing.Size(620, 50)
$lblFileInfo.TextAlign = 'MiddleCenter'
$lblFileInfo.Location = New-Object System.Drawing.Point(50, 250)
$form.Controls.Add($lblFileInfo)

# --------- NHẬP THỦ CÔNG ------------
$lblManual = New-Object System.Windows.Forms.Label
$lblManual.Text = "Hoặc nhập địa chỉ thủ công (mỗi dòng 1 địa chỉ):"
$lblManual.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 10)
$lblManual.Location = New-Object System.Drawing.Point(50, 310)
$form.Controls.Add($lblManual)

$txtManual = New-Object System.Windows.Forms.TextBox
$txtManual.Multiline = $true
$txtManual.ScrollBars = 'Vertical'
$txtManual.Font = New-Object System.Drawing.Font("Consolas", 10)
$txtManual.Size = New-Object System.Drawing.Size(620, 120)
$txtManual.Location = New-Object System.Drawing.Point(50, 335)
$txtManual.BackColor = [System.Drawing.Color]::White
$form.Controls.Add($txtManual)

# --------- PROGRESS BAR ------------
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Size = New-Object System.Drawing.Size(620, 25)
$progressBar.Location = New-Object System.Drawing.Point(50, 475)
$progressBar.Style = 'Continuous'
$progressBar.Visible = $false
$form.Controls.Add($progressBar)

$lblProgress = New-Object System.Windows.Forms.Label
$lblProgress.Font = $fontMain
$lblProgress.ForeColor = $textColor
$lblProgress.Size = New-Object System.Drawing.Size(620, 25)
$lblProgress.Location = New-Object System.Drawing.Point(50, 505)
$lblProgress.TextAlign = 'MiddleCenter'
$lblProgress.Visible = $false
$form.Controls.Add($lblProgress)

# --------- NÚT BẮT ĐẦU ------------
$btnStart = New-Object System.Windows.Forms.Button
$btnStart.Text = "🚀 BẮT ĐẦU KIỂM TRA"
$btnStart.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 12)
$btnStart.Size = New-Object System.Drawing.Size(300, 50)
$btnStart.Location = New-Object System.Drawing.Point(210, 540)
$btnStart.BackColor = $primaryColor
$btnStart.ForeColor = [System.Drawing.Color]::White
$btnStart.FlatStyle = 'Flat'
$btnStart.FlatAppearance.BorderSize = 0
$btnStart.Cursor = [System.Windows.Forms.Cursors]::Hand
$form.Controls.Add($btnStart)

$btnStart.Add_MouseEnter({ $btnStart.BackColor = [System.Drawing.Color]::FromArgb(0, 90, 190) })
$btnStart.Add_MouseLeave({ $btnStart.BackColor = $primaryColor })

# --------- DRAG & CLICK CSV ------------
$panelDrop.Add_DragEnter({
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
        $_.Effect = [Windows.Forms.DragDropEffects]::Copy
        $panelDrop.BackColor = [System.Drawing.Color]::FromArgb(240, 248, 255)
    }
})
$panelDrop.Add_DragLeave({ $panelDrop.BackColor = $panelColor })
$panelDrop.Add_DragDrop({
    $panelDrop.BackColor = $panelColor
    $files = $_.Data.GetData([Windows.Forms.DataFormats]::FileDrop)
    if ($files.Length -gt 0) {
        $file = $files[0]
        if ($file -match '\.csv$') { ProcessCSV $file }
        else { [System.Windows.Forms.MessageBox]::Show("Vui lòng chọn file CSV!", "Lỗi", "OK", "Error") }
    }
})
$panelDrop.Add_Click({
    $dlg = New-Object System.Windows.Forms.OpenFileDialog
    $dlg.Filter = "CSV files (*.csv)|*.csv"
    if ($dlg.ShowDialog() -eq "OK") { ProcessCSV $dlg.FileName }
})

# --------- HÀM XỬ LÝ CSV ------------
function ProcessCSV($file) {
    try {
        $csv = Import-Csv $file
        if (-not $csv[0].PSObject.Properties.Name -contains "Address") {
            [System.Windows.Forms.MessageBox]::Show("File CSV phải có cột 'Address'!", "Lỗi", "OK", "Error")
            return
        }
        $global:addresses = $csv | Select-Object -ExpandProperty Address | ForEach-Object { $_.Trim() }
        $global:csvPath = $file
        $lblFileInfo.Text = "✅ Đã chọn: $(Split-Path $file -Leaf)`n📊 $($global:addresses.Count) địa chỉ"
        $lblIcon.Text = "✅"
        $lblDrop.Text = "Sẵn sàng kiểm tra!"
        $lblDrop.ForeColor = $accentColor
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Lỗi đọc file: $_", "Lỗi", "OK", "Error")
    }
}

# --------- NÚT KIỂM TRA ------------
$btnStart.Add_Click({
    $manual = $txtManual.Text -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
    $addresses = @()
    if ($global:addresses.Count -gt 0) { $addresses += $global:addresses }
    if ($manual.Count -gt 0) { $addresses += $manual }

    if ($addresses.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Chưa có địa chỉ nào!", "Cảnh báo", "OK", "Warning")
        return
    }

    $btnStart.Enabled = $false
    $progressBar.Visible = $true
    $lblProgress.Visible = $true
    $progressBar.Value = 0

    $totalReceipts = 0
    $totalNight = 0
    $rows = @()
    $count = $addresses.Count
    $wallets = 0
    $remain = 0
    $globalTotal = 0

    for ($i = 0; $i -lt $count; $i++) {
        $a = $addresses[$i]
        $progressBar.Value = [int](($i + 1) / $count * 100)
        $lblProgress.Text = "🔍 $($i+1)/$count - $a"
        $form.Refresh()
        try {
            $url = "https://scavenger.prod.gd.midnighttge.io/statistics/$a"
            $r = Invoke-RestMethod -Uri $url -UseBasicParsing -TimeoutSec 10
            $crypto = [int]$r.local.crypto_receipts
            $night = [math]::Round(($r.local.night_allocation / 1000000), 2)
            $wallets = $r.global.wallets
            $remain = $r.global.total_challenges - $r.global.challenges
            $globalTotal = $r.global.total_crypto_receipts
        } catch {
            $crypto = 0
            $night = 0
        }

        $totalReceipts += $crypto
        $totalNight += $night
        $rows += [PSCustomObject]@{
            Address         = $a
            CryptoReceipts  = $crypto
            NightAllocation = $night
        }
        Start-Sleep -Milliseconds 400
    }

    $output = Join-Path (Split-Path $global:csvPath -Parent) ("crypto_results_{0:yyyyMMdd_HHmmss}.csv" -f (Get-Date))
    $rows | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $output
    $progressBar.Visible = $false
    $lblProgress.Visible = $false

    # Tính tương quan %
    if ($globalTotal -gt 0) {
        $ratio = [math]::Round(($totalReceipts / $globalTotal) * 100, 6)
    } else {
        $ratio = 0
    }

    $msg = "✅ Hoàn thành!`n`n"
    $msg += "📊 Tổng địa chỉ của bạn: $count`n"
    $msg += "💰 Tổng Solution: $totalReceipts`n"
    $msg += "🌙 Tổng Night tạm tính: {0:N2}`n" -f $totalNight
    $msg += "🪙 Địa chỉ tham gia toàn mạng: $wallets`n"
    $msg += "🎯 Cơ hội còn lại: $remain`n"
    $msg += "📈 Tương quan đóng góp: {0:N6} % tổng mạng`n`n" -f $ratio
    $msg += "📁 File kết quả: `n$output`n`nBạn có muốn mở file?"

    $res = [System.Windows.Forms.MessageBox]::Show($msg, "Xong", "YesNo", "Information")
    if ($res -eq "Yes") { Start-Process $output }
    $btnStart.Enabled = $true
})

# --------- HIỂN THỊ ------------
$form.ShowDialog() | Out-Null
