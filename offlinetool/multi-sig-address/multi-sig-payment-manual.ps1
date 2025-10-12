<#
PowerShell Manual Cardano Multisig Address Flow with Interactive Navigation
Bilingual Support: English & Vietnamese
- Creates multisig wallets using shared derivation path (1854H)
- Supports M-of-N signatures with optional time constraints
- Interactive navigation: confirm, redo, go back, or jump to specific steps
- Generates or uses existing mnemonics for multiple participants

USAGE:
- Place this script in the same folder as your cardano-address executable.
- Run PowerShell and execute: .\multisig.ps1
- IMPORTANT: This script writes private keys to disk. Handle them securely and delete when done.
#>
param(
    [switch]$UseMainnet
)

# Ensure working dir = folder containing this script/exe
try {
    $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
    if ($scriptPath) { Set-Location -Path $scriptPath }
} catch { }

# Language selection
Write-Host "╔════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║      Cardano Multisig Address Generator - Language Selection       ║" -ForegroundColor Cyan
Write-Host "║      Tạo Địa Chỉ Multisig Cardano - Chọn Ngôn Ngữ                  ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "Select your language / Chọn ngôn ngữ:"
Write-Host "  [1] English"
Write-Host "  [2] Tiếng Việt"
Write-Host ""
$langChoice = Read-Host "Enter choice / Nhập lựa chọn (1 or 2)"

$script:lang = if ($langChoice -eq "2") { "vi" } else { "en" }

# Language strings
$script:strings = @{
    en = @{
        # Common
        yes = "Y"
        no = "N"
        enter = "Enter"
        continue = "Continue"
        pressEnter = "Press Enter to continue"
        
        # Menu
        menuContinue = "[C] Continue to next step (default)"
        menuRedo = "[R] Redo this step"
        menuBack = "[B] Go back to previous step"
        menuGoto = "[G] Go to specific step (1-5)"
        menuQuit = "[Q] Quit"
        menuPrompt = "Enter choice"
        stepCompleted = "Step {0}: {1} - Completed"
        whatNext = "What would you like to do next?"
        
        # Step 0: Initialize
        welcomeTitle = "Cardano Multisig Address Generator - Interactive Flow"
        usageGuide = "USAGE GUIDE:"
        usageDesc = "  • This script will guide you through 5 steps to create multisig addresses"
        usageNav = "  • After each step, you can:"
        usageNav1 = "    - Continue to next step"
        usageNav2 = "    - Redo current step"
        usageNav3 = "    - Go back to previous step"
        usageNav4 = "    - Jump to specific step"
        stepsTitle = "STEPS:"
        step1Desc = "  1. Select network (mainnet/testnet)"
        step2Desc = "  2. Setup participants (mnemonics for each participant)"
        step3Desc = "  3. Derive keys for all participants (1854H shared path)"
        step4Desc = "  4. Configure multisig policy (M-of-N, time constraints)"
        step5Desc = "  5. Generate multisig address"
        securityTitle = "⚠️  SECURITY IMPORTANT:"
        security1 = "  • This script creates files containing private keys"
        security2 = "  • Keep these files safe and DO NOT share"
        security3 = "  • Delete temporary files after use"
        security4 = "  • Each participant should keep their own keys secure"
        checkingExe = "Checking for cardano-address executable..."
        exeNotFound = "❌ cardano-address executable not found in current directory!"
        exeDownload = "   Please download cardano-address and place it in the same folder as this script."
        exeDownloadUrl = "   Download at: https://github.com/input-output-hk/cardano-addresses/releases"
        exeFound = "✓ Found: {0}"
        pressStart = "Press Enter to start"
        
        # Step 1: Network
        step1Title = "STEP 1: Select Network"
        selectNetwork = "Selected network: {0}"
        useTestnet = "Use testnet? (default No = mainnet)"
        
        # Step 2: Participants
        step2Title = "STEP 2: Setup Participants"
        enterParticipantCount = "Enter total number of participants (M)"
        participantSetup = "Setting up participant #{0}: {1}"
        enterParticipantName = "Enter name for participant #{0} (e.g., alice, bob, charlie)"
        chooseMnemonicMethod = "Choose mnemonic method for {0}:"
        mnemonicGenerate = "  [1] Generate new mnemonic (default)"
        mnemonicManual = "  [2] Enter mnemonic manually"
        mnemonicFile = "  [3] Use existing file"
        mnemonicChoice = "Enter choice (1/2/3)"
        enterWordCount = "Enter number of words (9, 12, 15, 18, 21 24) [default: 15]"
        generatingMnemonic = "Generating mnemonic for {0}..."
        mnemonicSaved = "Mnemonic saved to: {0}"
        enterMnemonic = "Enter mnemonic words (space separated) for {0}"
        enterFilePath = "Enter path to mnemonic file for {0}"
        fileNotFound = "File not found: {0}"
        participantsCreated = "All {0} participants created successfully"
        
        # Step 3: Derive Keys
        step3Title = "STEP 3: Derive Keys for All Participants"
        chooseIndexMethod = "Choose payment index method:"
        indexMethodManual = "  [1] Enter index manually (default)"
        indexMethodFile = "  [2] Load from saved address file"
        indexMethodInput = "  [3] Input address manually"
        indexMethodChoice = "Enter choice (1/2/3)"
        enterPaymentIndex = "Enter payment key index (0-2147483647) [default: 0]"
        enterAddressFile = "Enter path to saved address file"
        enterAddress = "Enter address manually"
        derivingKeys = "Deriving keys for participant: {0}"
        derivingRoot = "  → Deriving root key..."
        derivingPayment = "  → Deriving payment key (1854H/1815H/0H/0/{0})..."
        exportingPublic = "  → Exporting public key..."
        calculatingHash = "  → Calculating key hash..."
        generatingPaymentAddr = "  → Generating individual payment address..."
        keysDerived = "Keys derived for: {0}"
        keyHash = "    Key hash: {0}"
        paymentAddr = "    Payment address: {0}"
        allKeysDerived = "All participant keys derived successfully"
        
        # Step 4: Configure Policy
        step4Title = "STEP 4: Configure Multisig Policy"
        enterThreshold = "Enter signature threshold N (minimum signatures required, 1-{0})"
        thresholdSet = "Threshold set: {0} of {1} signatures required"
        useTimeConstraints = "Add time constraints? (active_from/active_until)"
        enterActiveFrom = "Enter active_from slot (Enter to skip)"
        enterActiveUntil = "Enter active_until slot (Enter to skip)"
        activeFromSet = "Active from slot: {0}"
        activeUntilSet = "Active until slot: {0}"
        noTimeConstraints = "No time constraints set"
        policyExpression = "Multisig policy expression:"
        policyConfigured = "Multisig policy configured successfully"
        
        # Step 5: Generate Address
        step5Title = "STEP 5: Generate Multisig Address"
        generatingPolicy = "Generating policy ID..."
        policyId = "Policy ID: {0}"
        generatingAddress = "Generating multisig payment address..."
        multisigAddress = "Multisig Address: {0}"
        savingFiles = "Saving policy and address files..."
        addressGenerated = "Multisig address generated successfully"
        
        # Final
        completedTitle = "COMPLETED - MULTISIG ADDRESS CREATION"
        filesCreated = "Files created in keys/ folder:"
        participantFiles = "Participant {0} ({1}):"
        file1 = "  📄 {0}.phrase     - Mnemonic phrase"
        file2 = "  🔐 {0}.root.xsk   - Root private key"
        file3 = "  🔐 {0}.pay.{1}.xsk - Payment private key"
        file4 = "  🔓 {0}.pay.{1}.xvk - Payment public key"
        file5 = "  🔑 {0}.hash       - Key hash"
        file6 = "  💳 {0}.payment.addr - Individual payment address"
        policyFiles = "Multisig Policy Files:"
        file7 = "  📜 policy.txt         - Policy expression"
        file8 = "  🆔 policy_id.txt      - Policy ID"
        file9 = "  ⭐ multisig.addr      - Multisig payment address (use this!)"
        securityNotesTitle = "⚠️  SECURITY NOTES:"
        secNote1 = "  • .xsk files contain private keys - NEVER share them"
        secNote2 = "  • Each participant should keep only their own keys"
        secNote3 = "  • Minimum {0} participants must sign transactions"
        secNote4 = "  • All participants need their private keys to sign"
        secNote5 = "  • Delete temporary files after moving to secure storage"
        useMultisigAddr = "✓ Use multisig.addr to receive ADA (requires {0}-of-{1} signatures to spend)"
        useIndividualAddr = "✓ Each participant can use their .payment.addr for individual transactions (1 signature)"
        
        # Errors
        stepFailed = "Step {0} failed. Please try again."
        retryStep = "Retry this step?"
        alreadyFirstStep = "Already at first step."
        invalidStepNumber = "Invalid step number. Staying at current step."
        quitting = "Quitting..."
        gotoPrompt = "Enter step number (1-5)"
        invalidNumber = "Invalid number. Please try again."
        invalidThreshold = "Threshold must be between 1 and {0}"
    }
    vi = @{
        # Common
        yes = "C"
        no = "K"
        enter = "Enter"
        continue = "Tiếp tục"
        pressEnter = "Nhấn Enter để tiếp tục"
        
        # Menu
        menuContinue = "[C] Tiếp tục bước tiếp theo (mặc định)"
        menuRedo = "[R] Làm lại bước này"
        menuBack = "[B] Quay lại bước trước"
        menuGoto = "[G] Nhảy đến bước cụ thể (1-5)"
        menuQuit = "[Q] Thoát"
        menuPrompt = "Nhập lựa chọn"
        stepCompleted = "Bước {0}: {1} - Hoàn thành"
        whatNext = "Bạn muốn làm gì tiếp theo?"
        
        # Step 0: Initialize
        welcomeTitle = "Tạo Địa Chỉ Multisig Cardano - Hướng Dẫn Tương Tác"
        usageGuide = "HƯỚNG DẪN SỬ DỤNG:"
        usageDesc = "  • Script này sẽ hướng dẫn bạn tạo địa chỉ multisig qua 5 bước"
        usageNav = "  • Sau mỗi bước, bạn có thể:"
        usageNav1 = "    - Tiếp tục bước tiếp theo"
        usageNav2 = "    - Làm lại bước hiện tại"
        usageNav3 = "    - Quay lại bước trước để chỉnh sửa"
        usageNav4 = "    - Nhảy đến bước cụ thể"
        stepsTitle = "CÁC BƯỚC THỰC HIỆN:"
        step1Desc = "  1. Chọn network (mainnet/testnet)"
        step2Desc = "  2. Thiết lập người tham gia (mnemonic cho từng người)"
        step3Desc = "  3. Tạo key cho tất cả người tham gia (đường dẫn 1854H shared)"
        step4Desc = "  4. Cấu hình multisig policy (M-of-N, ràng buộc thời gian)"
        step5Desc = "  5. Tạo multisig address"
        securityTitle = "⚠️  BẢO MẬT QUAN TRỌNG:"
        security1 = "  • Script này tạo các file chứa private keys"
        security2 = "  • Giữ các file này an toàn và KHÔNG chia sẻ"
        security3 = "  • Xóa các file tạm sau khi sử dụng xong"
        security4 = "  • Mỗi người tham gia phải giữ key của mình an toàn"
        checkingExe = "Đang kiểm tra cardano-address executable..."
        exeNotFound = "❌ Không tìm thấy cardano-address executable trong thư mục hiện tại!"
        exeDownload = "   Vui lòng tải cardano-address và đặt cùng thư mục với script này."
        exeDownloadUrl = "   Tải tại: https://github.com/input-output-hk/cardano-addresses/releases"
        exeFound = "✓ Tìm thấy: {0}"
        pressStart = "Nhấn Enter để bắt đầu"
        
        # Step 1: Network
        step1Title = "BƯỚC 1: Chọn Network"
        selectNetwork = "Đã chọn network: {0}"
        useTestnet = "Sử dụng testnet? (mặc định Không = mainnet)"
        
        # Step 2: Participants
        step2Title = "BƯỚC 2: Thiết Lập Người Tham Gia"
        enterParticipantCount = "Nhập tổng số người tham gia (M)"
        participantSetup = "Thiết lập người tham gia #{0}: {1}"
        enterParticipantName = "Nhập tên cho người tham gia #{0} (vd: alice, bob, charlie)"
        chooseMnemonicMethod = "Chọn phương thức mnemonic cho {0}:"
        mnemonicGenerate = "  [1] Tạo mnemonic mới (mặc định)"
        mnemonicManual = "  [2] Nhập mnemonic thủ công"
        mnemonicFile = "  [3] Dùng file có sẵn"
        mnemonicChoice = "Nhập lựa chọn (1/2/3)"
        enterWordCount = "Nhập số (9, 12, 15, 18, 21 24) [mặc định: 15]"
        generatingMnemonic = "Đang tạo mnemonic cho {0}..."
        mnemonicSaved = "Mnemonic đã lưu vào: {0}"
        enterMnemonic = "Nhập các từ mnemonic (cách nhau bởi dấu cách) cho {0}"
        enterFilePath = "Nhập đường dẫn file mnemonic cho {0}"
        fileNotFound = "Không tìm thấy file: {0}"
        participantsCreated = "Đã tạo thành công {0} người tham gia"
        
        # Step 3: Derive Keys
        step3Title = "BƯỚC 3: Tạo Key Cho Tất Cả Người Tham Gia"
        chooseIndexMethod = "Chọn phương thức nhập payment index:"
        indexMethodManual = "  [1] Nhập index thủ công (mặc định)"
        indexMethodFile = "  [2] Tải từ file địa chỉ có sẵn"
        indexMethodInput = "  [3] Nhập địa chỉ thủ công"
        indexMethodChoice = "Nhập lựa chọn (1/2/3)"
        enterPaymentIndex = "Nhập payment key index (0-2147483647) [mặc định: 0]"
        enterAddressFile = "Nhập đường dẫn đến file địa chỉ"
        enterAddress = "Nhập địa chỉ thủ công"
        derivingKeys = "Đang tạo key cho người tham gia: {0}"
        derivingRoot = "  → Đang tạo root key..."
        derivingPayment = "  → Đang tạo payment key (1854H/1815H/0H/0/{0})..."
        exportingPublic = "  → Đang xuất public key..."
        calculatingHash = "  → Đang tính key hash..."
        generatingPaymentAddr = "  → Đang tạo địa chỉ payment cá nhân..."
        keysDerived = "Đã tạo key cho: {0}"
        keyHash = "    Key hash: {0}"
        paymentAddr = "    Địa chỉ payment: {0}"
        allKeysDerived = "Đã tạo key thành công cho tất cả người tham gia"
        
        # Step 4: Configure Policy
        step4Title = "BƯỚC 4: Cấu Hình Multisig Policy"
        enterThreshold = "Nhập ngưỡng chữ ký N (số chữ ký tối thiểu, 1-{0})"
        thresholdSet = "Đã thiết lập ngưỡng: cần {0} trong {1} chữ ký"
        useTimeConstraints = "Thêm ràng buộc thời gian? (active_from/active_until)"
        enterActiveFrom = "Nhập active_from slot (Enter để bỏ qua)"
        enterActiveUntil = "Nhập active_until slot (Enter để bỏ qua)"
        activeFromSet = "Active từ slot: {0}"
        activeUntilSet = "Active đến slot: {0}"
        noTimeConstraints = "Không có ràng buộc thời gian"
        policyExpression = "Biểu thức multisig policy:"
        policyConfigured = "Đã cấu hình multisig policy thành công"
        
        # Step 5: Generate Address
        step5Title = "BƯỚC 5: Tạo Multisig Address"
        generatingPolicy = "Đang tạo policy ID..."
        policyId = "Policy ID: {0}"
        generatingAddress = "Đang tạo multisig payment address..."
        multisigAddress = "Multisig Address: {0}"
        savingFiles = "Đang lưu file policy và address..."
        addressGenerated = "Đã tạo multisig address thành công"
        
        # Final
        completedTitle = "HOÀN THÀNH TẠO MULTISIG ADDRESS"
        filesCreated = "Các file đã tạo trong thư mục keys/:"
        participantFiles = "Người tham gia {0} ({1}):"
        file1 = "  📄 {0}.phrase     - Mnemonic phrase"
        file2 = "  🔐 {0}.root.xsk   - Root private key"
        file3 = "  🔐 {0}.pay.{1}.xsk - Payment private key"
        file4 = "  🔓 {0}.pay.{1}.xvk - Payment public key"
        file5 = "  🔑 {0}.hash       - Key hash"
        file6 = "  💳 {0}.payment.addr - Địa chỉ payment cá nhân"
        policyFiles = "File Multisig Policy:"
        file7 = "  📜 policy.txt         - Biểu thức policy"
        file8 = "  🆔 policy_id.txt      - Policy ID"
        file9 = "  ⭐ multisig.addr      - Multisig payment address (dùng cái này!)"
        securityNotesTitle = "⚠️  LƯU Ý BẢO MẬT:"
        secNote1 = "  • Các file .xsk chứa private keys - TUYỆT ĐỐI KHÔNG chia sẻ"
        secNote2 = "  • Mỗi người tham gia chỉ nên giữ key của mình"
        secNote3 = "  • Cần tối thiểu {0} người tham gia ký giao dịch"
        secNote4 = "  • Tất cả người tham gia cần private keys để ký"
        secNote5 = "  • Xóa các file tạm sau khi chuyển vào lưu trữ an toàn"
        useMultisigAddr = "✓ Dùng multisig.addr để nhận ADA (cần {0}-trong-{1} chữ ký để chi tiêu)"
        useIndividualAddr = "✓ Mỗi người có thể dùng .payment.addr để giao dịch cá nhân (1 chữ ký)"
        
        # Errors
        stepFailed = "Bước {0} thất bại. Vui lòng thử lại."
        retryStep = "Thử lại bước này?"
        alreadyFirstStep = "Đã ở bước đầu tiên."
        invalidStepNumber = "Số bước không hợp lệ. Ở lại bước hiện tại."
        quitting = "Đang thoát..."
        gotoPrompt = "Nhập số bước (1-5)"
        invalidNumber = "Số không hợp lệ. Vui lòng thử lại."
        invalidThreshold = "Ngưỡng phải từ 1 đến {0}"
    }
}

function Get-Text($key) {
    return $script:strings[$script:lang][$key]
}

function Prompt-YesNo($msg, $defaultYes=$true) {
    $choice = Read-Host "$msg [Y/N]"
    if ([string]::IsNullOrWhiteSpace($choice)) { return $defaultYes }
    return $choice.Trim().ToUpper().StartsWith('Y')
}

function Show-StepMenu($stepName, $currentStep) {
    Write-Host "`n─────────────────────────────────────────────────────────────────────" -ForegroundColor Yellow
    Write-Host ("✓ " + (Get-Text "stepCompleted") -f $currentStep, $stepName) -ForegroundColor Green
    Write-Host "─────────────────────────────────────────────────────────────────────" -ForegroundColor Yellow
    Write-Host (Get-Text "whatNext")
    Write-Host (Get-Text "menuContinue")
    Write-Host (Get-Text "menuRedo")
    Write-Host (Get-Text "menuBack")
    Write-Host (Get-Text "menuGoto")
    Write-Host (Get-Text "menuQuit")
    
    $choice = Read-Host (Get-Text "menuPrompt")
    if ([string]::IsNullOrWhiteSpace($choice)) { return @{action='continue'} }
    
    switch ($choice.Trim().ToUpper()) {
        'C' { return @{action='continue'} }
        'R' { return @{action='redo'} }
        'B' { return @{action='back'} }
        'G' { 
            $targetStep = Read-Host (Get-Text "gotoPrompt")
            return @{action='goto'; step=[int]$targetStep}
        }
        'Q' { return @{action='quit'} }
        default { return @{action='continue'} }
    }
}

function Step-Initialize {
    Write-Host "`n╔════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host ("║  " + (Get-Text "welcomeTitle").PadRight(66) + "║") -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    
    Write-Host ("`n" + (Get-Text "usageGuide")) -ForegroundColor Yellow
    Write-Host (Get-Text "usageDesc")
    Write-Host (Get-Text "usageNav")
    Write-Host (Get-Text "usageNav1")
    Write-Host (Get-Text "usageNav2")
    Write-Host (Get-Text "usageNav3")
    Write-Host (Get-Text "usageNav4")
    Write-Host ""
    Write-Host (Get-Text "stepsTitle") -ForegroundColor Yellow
    Write-Host (Get-Text "step1Desc")
    Write-Host (Get-Text "step2Desc")
    Write-Host (Get-Text "step3Desc")
    Write-Host (Get-Text "step4Desc")
    Write-Host (Get-Text "step5Desc")
    Write-Host ""
    Write-Host (Get-Text "securityTitle") -ForegroundColor Red
    Write-Host (Get-Text "security1")
    Write-Host (Get-Text "security2")
    Write-Host (Get-Text "security3")
    Write-Host (Get-Text "security4")
    Write-Host ""
    
    # Locate cardano-address executable
    Write-Host (Get-Text "checkingExe") -ForegroundColor Cyan
    $exePaths = @(".\cardano-address.exe", ".\cardano-address")
    $script:cardanoExe = $null
    foreach ($p in $exePaths) {
        if (Test-Path $p) { $script:cardanoExe = $p; break }
    }
    if (-not $script:cardanoExe) {
        Write-Host ""
        Write-Error (Get-Text "exeNotFound")
        Write-Host (Get-Text "exeDownload") -ForegroundColor Yellow
        Write-Host (Get-Text "exeDownloadUrl") -ForegroundColor Yellow
        return $false
    }
    Write-Host ((Get-Text "exeFound") -f $script:cardanoExe) -ForegroundColor Green
    
    # Create keys directory
    $script:keysDir = ".\keys"
    if (-not (Test-Path $script:keysDir)) {
        New-Item -ItemType Directory -Path $script:keysDir | Out-Null
    }
    
    Write-Host ""
    $null = Read-Host (Get-Text "pressStart")
    return $true
}

function Step-SelectNetwork {
    Write-Host ("`n=== " + (Get-Text "step1Title") + " ===") -ForegroundColor Cyan
    
    if ($UseMainnet) {
        $script:networkTag = "mainnet"
    } else {
        $isTest = Prompt-YesNo (Get-Text "useTestnet") $false
        $script:networkTag = if ($isTest) { "testnet" } else { "mainnet" }
    }
    Write-Host ((Get-Text "selectNetwork") -f $script:networkTag) -ForegroundColor Green
    return $true
}

function Step-SetupParticipants {
    Write-Host ("`n=== " + (Get-Text "step2Title") + " ===") -ForegroundColor Cyan
    
    # Get number of participants
    $countInput = Read-Host (Get-Text "enterParticipantCount")
    try {
        $script:participantCount = [int]$countInput
        if ($script:participantCount -lt 1) { throw }
    } catch {
        Write-Error (Get-Text "invalidNumber")
        return $false
    }
    
    $script:participants = @()
    
    for ($i = 1; $i -le $script:participantCount; $i++) {
        Write-Host ("`n" + ((Get-Text "participantSetup") -f $i, "")) -ForegroundColor Yellow
        
        # Get participant name
        $name = Read-Host ((Get-Text "enterParticipantName") -f $i)
        if ([string]::IsNullOrWhiteSpace($name)) { 
            $name = "participant$i"
        }
        
        # Choose mnemonic method
        Write-Host ((Get-Text "chooseMnemonicMethod") -f $name)
        Write-Host (Get-Text "mnemonicGenerate")
        Write-Host (Get-Text "mnemonicManual")
        Write-Host (Get-Text "mnemonicFile")
        
        $method = Read-Host (Get-Text "mnemonicChoice")
        if ([string]::IsNullOrWhiteSpace($method)) { $method = "G" }
        
        $phraseFile = Join-Path $script:keysDir "$name.phrase"
        
        switch ($method.Trim().ToUpper()) {
            'M' {
                # Manual entry
                $mnemonic = Read-Host ((Get-Text "enterMnemonic") -f $name)
                Set-Content -Path $phraseFile -Value $mnemonic -Encoding UTF8
                Write-Host ((Get-Text "mnemonicSaved") -f $phraseFile) -ForegroundColor Green
            }
            'F' {
                # From file
                $srcFile = Read-Host ((Get-Text "enterFilePath") -f $name)
                if (-not (Test-Path $srcFile)) {
                    Write-Error ((Get-Text "fileNotFound") -f $srcFile)
                    return $false
                }
                Copy-Item $srcFile $phraseFile -Force
                Write-Host ((Get-Text "mnemonicSaved") -f $phraseFile) -ForegroundColor Green
            }
            default {
                # Generate
                $sizeInput = Read-Host (Get-Text "enterWordCount")
                $size = if ([string]::IsNullOrWhiteSpace($sizeInput)) { "15" } else { $sizeInput }
                
                Write-Host ((Get-Text "generatingMnemonic") -f $name)
                $mnemonic = & $script:cardanoExe recovery-phrase generate --size $size
                if ($LASTEXITCODE -ne 0) {
                    Write-Error "Failed to generate mnemonic"
                    return $false
                }
                Set-Content -Path $phraseFile -Value $mnemonic -Encoding UTF8
                Write-Host ((Get-Text "mnemonicSaved") -f $phraseFile) -ForegroundColor Green
            }
        }
        
        $script:participants += @{
            Name = $name
            PhraseFile = $phraseFile
        }
    }
    
    Write-Host ("`n" + ((Get-Text "participantsCreated") -f $script:participantCount)) -ForegroundColor Green
    return $true
}

function Step-DeriveKeys {
    Write-Host ("`n=== " + (Get-Text "step3Title") + " ===") -ForegroundColor Cyan
    
    $script:keyHashes = @()
    
    foreach ($participant in $script:participants) {
        $name = $participant.Name
        Write-Host "`n$("-" * 50)"
        Write-Host "Processing participant: $name"
        Write-Host (Get-Text "chooseIndexMethod")
        Write-Host (Get-Text "indexMethodManual")
        Write-Host (Get-Text "indexMethodFile")
        Write-Host (Get-Text "indexMethodInput")
        
        $methodChoice = Read-Host (Get-Text "indexMethodChoice")
        if ([string]::IsNullOrWhiteSpace($methodChoice)) { $methodChoice = "1" }
        
        switch ($methodChoice) {
            "1" {
                # Manual index input
                $indexInput = Read-Host (Get-Text "enterPaymentIndex")
                $participant.PaymentIndex = if ([string]::IsNullOrWhiteSpace($indexInput)) { "0" } else { $indexInput }
            }
            "2" {
                # Load from saved address file
                $addressFile = Read-Host (Get-Text "enterAddressFile")
                
                # Resolve relative path if needed
                if (-not [System.IO.Path]::IsPathRooted($addressFile)) {
                    $addressFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PWD.Path, $addressFile))
                }
                
                if (Test-Path $addressFile) {
                    Write-Host "Đang đọc file: $addressFile"
                    try {
                        $addressContent = Get-Content $addressFile -Raw -ErrorAction Stop
                        $participant.Value = $addressContent.Trim()
                        Write-Host "Đã đọc nội dung file thành công" -ForegroundColor Green
                        $participant.PaymentIndex = "0"  # Default index since we're using the actual value
                    } catch {
                        Write-Host "Lỗi khi đọc file: $_" -ForegroundColor Red
                        Write-Host "Sử dụng index mặc định 0" -ForegroundColor Yellow
                        $participant.PaymentIndex = "0"
                    }
                } else {
                    Write-Host "Không tìm thấy file: $addressFile" -ForegroundColor Red
                    Write-Host "Đường dẫn đầy đủ đã thử: $([System.IO.Path]::GetFullPath($addressFile))" -ForegroundColor Yellow
                    Write-Host "Sử dụng index mặc định 0" -ForegroundColor Yellow
                    $participant.PaymentIndex = "0"
                }
            }
            "3" {
                # Manual address input
                $participant.Value = Read-Host (Get-Text "enterAddress")
                # When entering address manually, use default index
                $participant.PaymentIndex = "0"
            }
            default {
                Write-Host "Invalid choice. Using default index 0"
                $participant.PaymentIndex = "0"
            }
        }
    }
    
    foreach ($participant in $script:participants) {
        $name = $participant.Name
        Write-Host ("`n" + ((Get-Text "derivingKeys") -f $name)) -ForegroundColor Yellow
        
        # Derive root key
        Write-Host (Get-Text "derivingRoot")
        $rootFile = Join-Path $script:keysDir "$name.root.xsk"
        $phraseContent = Get-Content $participant.PhraseFile -Raw
        $rootKey = $phraseContent | & $script:cardanoExe key from-recovery-phrase Shelley
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Failed to derive root key for $name"
            return $false
        }
        Set-Content -Path $rootFile -Value $rootKey -NoNewline -Encoding ASCII
        
        # Derive payment key (1854H shared path)
        Write-Host ((Get-Text "derivingPayment") -f $participant.PaymentIndex)
        $payPath = "1854H/1815H/0H/0/$($participant.PaymentIndex)"
        $payFile = Join-Path $script:keysDir "$name.pay.$($participant.PaymentIndex).xsk"
        $rootKeyContent = Get-Content $rootFile -Raw
        $payKey = $rootKeyContent | & $script:cardanoExe key child $payPath
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Failed to derive payment key for $name"
            return $false
        }
        Set-Content -Path $payFile -Value $payKey -NoNewline -Encoding ASCII
        
        # Export public key
        Write-Host (Get-Text "exportingPublic")
        $xvkFile = Join-Path $script:keysDir "$name.pay.$($script:paymentIndex).xvk"
        $payKeyContent = Get-Content $payFile -Raw
        $pubKey = $payKeyContent | & $script:cardanoExe key public --without-chain-code
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Failed to export public key for $name"
            return $false
        }
        Set-Content -Path $xvkFile -Value $pubKey -NoNewline -Encoding ASCII
        
        # Calculate key hash
        Write-Host (Get-Text "calculatingHash")
        $xvkContent = Get-Content $xvkFile -Raw
        $keyHash = $xvkContent | & $script:cardanoExe key hash
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Failed to calculate key hash for $name"
            return $false
        }
        $keyHash = $keyHash.Trim()
        
        # Save hash to file
        $hashFile = Join-Path $script:keysDir "$name.hash"
        Set-Content -Path $hashFile -Value $keyHash -Encoding UTF8
        
        # Generate individual payment address for this participant
        Write-Host (Get-Text "generatingPaymentAddr")
        $paymentAddr = $xvkContent | & $script:cardanoExe address payment --network-tag $script:networkTag
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Failed to generate payment address for $name"
            $paymentAddr = $null
        } else {
            $paymentAddr = $paymentAddr.Trim()
            $paymentAddrFile = Join-Path $script:keysDir "$name.payment.addr"
            Set-Content -Path $paymentAddrFile -Value $paymentAddr -Encoding UTF8
        }
        
        Write-Host ((Get-Text "keysDerived") -f $name) -ForegroundColor Green
        Write-Host ((Get-Text "keyHash") -f $keyHash) -ForegroundColor Cyan
        if ($paymentAddr) {
            Write-Host ((Get-Text "paymentAddr") -f $paymentAddr) -ForegroundColor Magenta
        }
        
        $script:keyHashes += $keyHash
        $participant.KeyHash = $keyHash
        $participant.XvkFile = $xvkFile
        $participant.PaymentAddr = $paymentAddr
    }
    
    Write-Host ("`n" + (Get-Text "allKeysDerived")) -ForegroundColor Green
    return $true
}

function Convert-UnixTimeToUTC {
    param (
        [Parameter(Mandatory=$true)]
        [int64]$UnixTime
    )
    try {
        $epoch = [DateTime]::new(1970, 1, 1, 0, 0, 0, [DateTimeKind]::Utc)
        return $epoch.AddSeconds($UnixTime).ToString("yyyy-MM-dd HH:mm:ss UTC")
    } catch {
        return "Invalid timestamp"
    }
}

function Show-PolicyInfo {
    param (
        [int]$RequiredSigners,
        [int]$TotalParticipants,
        [int64]$ActiveFrom,
        [int64]$ActiveUntil
    )
    
    $border = "=" * 70
    Write-Host "`n$border"
    Write-Host "THÔNG TIN CHÍNH SÁCH MULTISIG" -ForegroundColor Cyan
    Write-Host $border
    
    Write-Host "Số người tham gia: " -NoNewline
    Write-Host $TotalParticipants -ForegroundColor Yellow
    
    Write-Host "Số chữ ký cần thiết: " -NoNewline
    Write-Host $RequiredSigners -ForegroundColor Yellow
    
    Write-Host "`nThời gian có hiệu lực:"
    Write-Host "  • Từ: " -NoNewline
    Write-Host (Convert-UnixTimeToUTC $ActiveFrom) -ForegroundColor Green
    Write-Host "  • Đến: " -NoNewline
    Write-Host (Convert-UnixTimeToUTC $ActiveUntil) -ForegroundColor Green
    
    # Additional security notes
    Write-Host "`nLƯU Ý QUAN TRỌNG:" -ForegroundColor Yellow
    Write-Host "• Cần $RequiredSigners/$TotalParticipants chữ ký để thực hiện giao dịch"
    Write-Host "• Chính sách chỉ có hiệu lực trong khoảng thời gian đã định"
    Write-Host "• Các giao dịch ngoài thời gian này sẽ bị từ chối"
    Write-Host $border
}

function Step-ConfigurePolicy {
    Write-Host ("`n=== " + (Get-Text "step4Title") + " ===") -ForegroundColor Cyan
    
    # Get threshold
    $thresholdInput = Read-Host ((Get-Text "enterThreshold") -f $script:participantCount)
    try {
        $script:threshold = [int]$thresholdInput
        if ($script:threshold -lt 1 -or $script:threshold -gt $script:participantCount) {
            Write-Error ((Get-Text "invalidThreshold") -f $script:participantCount)
            return $false
        }
    } catch {
        Write-Error (Get-Text "invalidNumber")
        return $false
    }
    
    Write-Host ((Get-Text "thresholdSet") -f $script:threshold, $script:participantCount) -ForegroundColor Green
    
    # Time constraints
    $useTime = Prompt-YesNo (Get-Text "useTimeConstraints") $false
    
    $script:activeFrom = $null
    $script:activeUntil = $null
    
    if ($useTime) {
        $fromInput = Read-Host (Get-Text "enterActiveFrom")
        if (-not [string]::IsNullOrWhiteSpace($fromInput)) {
            try {
                $script:activeFrom = [int]$fromInput
                Write-Host ((Get-Text "activeFromSet") -f $script:activeFrom) -ForegroundColor Green
            } catch {
                Write-Warning (Get-Text "invalidNumber")
            }
        }
        
        $untilInput = Read-Host (Get-Text "enterActiveUntil")
        if (-not [string]::IsNullOrWhiteSpace($untilInput)) {
            try {
                $script:activeUntil = [int]$untilInput
                Write-Host ((Get-Text "activeUntilSet") -f $script:activeUntil) -ForegroundColor Green
            } catch {
                Write-Warning (Get-Text "invalidNumber")
            }
        }
    } else {
        Write-Host (Get-Text "noTimeConstraints") -ForegroundColor Green
    }
    
    # Build policy JSON expression
    $signaturesJson = $script:keyHashes | ForEach-Object {
        @{
            "signature" = @{
                "verification_key" = $_
            }
        }
    }

    $atLeastJson = @{
        "at_least" = @{
            "required" = $script:threshold
            "signatures" = $signaturesJson
        }
    }
    
    if ($null -ne $script:activeFrom -or $null -ne $script:activeUntil) {
        $timeConstraints = @{}
        if ($null -ne $script:activeFrom) {
            $timeConstraints["active_from"] = @{ "slot" = $script:activeFrom }
        }
        if ($null -ne $script:activeUntil) {
            $timeConstraints["active_until"] = @{ "slot" = $script:activeUntil }
        }
        
        $script:policyExpr = @{
            "all" = @(
                $atLeastJson
                $timeConstraints
            )
        } | ConvertTo-Json -Depth 10 -Compress
    } else {
        $script:policyExpr = $atLeastJson | ConvertTo-Json -Depth 10 -Compress
    }
    
    Write-Host ("`n" + (Get-Text "policyExpression")) -ForegroundColor Yellow
    Write-Host $script:policyExpr -ForegroundColor Cyan
    
    Write-Host ("`n" + (Get-Text "policyConfigured")) -ForegroundColor Green
    return $true
}

function Step-GenerateAddress {
    Write-Host ("`n=== " + (Get-Text "step5Title") + " ===") -ForegroundColor Cyan
    
    # Build simple script command
    Write-Host (Get-Text "generatingPolicy")
    
    # Get all verification keys and combine them
    $keyList = $script:participants | ForEach-Object {
        Get-Content $_.XvkFile -Raw
    } | ForEach-Object { $_.Trim() }
    
    # Build the script command
    $scriptParts = $keyList
    
    # Add time constraints if specified
    if ($null -ne $script:activeFrom) {
        $scriptParts += "active_from $($script:activeFrom)"
    }
    if ($null -ne $script:activeUntil) {
        $scriptParts += "active_until $($script:activeUntil)"
    }
    
    # Build final command
    $finalCmd = "all [" + ($scriptParts -join ", ") + "]"
    
    # Save for reference
    $script:policyExpr = $finalCmd
    
    # Generate policy ID using simple script
    $script:policyId = & $script:cardanoExe script hash $finalCmd
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to generate policy ID"
        return $false
    }
    $script:policyId = $script:policyId.Trim()
    Write-Host ((Get-Text "policyId") -f $script:policyId) -ForegroundColor Cyan
    
    # Save policy ID to script.hash file
    $script:policyId | Out-File -FilePath "script.hash" -NoNewline
    
    # Generate multisig address using simple script
    Write-Host (Get-Text "generatingAddress")
    $script:multisigAddr = Get-Content "script.hash" | & $script:cardanoExe address payment --network-tag $script:networkTag
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to generate multisig address"
        return $false
    }
    $script:multisigAddr = $script:multisigAddr.Trim()
    Write-Host ((Get-Text "multisigAddress") -f $script:multisigAddr) -ForegroundColor Yellow
    
    # Save files
    Write-Host (Get-Text "savingFiles")
    $policyFile = Join-Path $script:keysDir "policy.json"
    $addrFile = Join-Path $script:keysDir "multisig.addr"
    
    Set-Content -Path $policyFile -Value $script:policyExpr -Encoding UTF8
    Set-Content -Path $addrFile -Value $script:multisigAddr -Encoding UTF8
    
    Write-Host ("`n" + (Get-Text "addressGenerated")) -ForegroundColor Green

    # Display final summary
    Show-CompletionSummary
    return $true
}

function Show-CompletionSummary {
    Write-Host "`n"
    Write-Host ("╔" + "═"*64 + "╗")
    Write-Host ("║  " + "HOÀN THÀNH TẠO MULTISIG ADDRESS".PadRight(62) + "║")
    Write-Host ("╚" + "═"*64 + "╝")
    Write-Host "`nCác file đã tạo trong thư mục keys/:`n"
    
    # Display participant 1 info
    Write-Host "Người tham gia 1 (1):"
    Write-Host "  📄 1.phrase     - Mnemonic phrase"
    Write-Host "  🔐 1.root.xsk   - Root private key"
    Write-Host "  🔐 1.pay.xsk    - Payment private key"
    Write-Host "  🔓 1.pay.xvk    - Payment public key"
    Write-Host "  🔑 1.hash       - Key hash`n"
    
    # Display participant 2 info
    Write-Host "Người tham gia 2 (2):"
    Write-Host "  📄 2.phrase     - Mnemonic phrase"
    Write-Host "  🔐 2.root.xsk   - Root private key"
    Write-Host "  🔐 2.pay.xsk    - Payment private key"
    Write-Host "  🔓 2.pay.xvk    - Payment public key"
    Write-Host "  🔑 2.hash       - Key hash`n"
    
    # Display multisig files
    Write-Host "File Multisig Policy:"
    Write-Host "  📜 policy.txt         - Biểu thức policy"
    Write-Host "  🆔 policy_id.txt      - Policy ID"
    Write-Host "  ⭐ multisig.addr      - Multisig payment address (dùng cái này!)`n"
    
    # Display security warnings
    Write-Host "⚠️  LƯU Ý BẢO MẬT:"
    Write-Host "  • Các file .xsk chứa private keys - TUYỆT ĐỐI KHÔNG chia sẻ"
    Write-Host "  • Mỗi người tham gia chỉ nên giữ key của mình"
    Write-Host "  • Cần tối thiểu 2 người tham gia ký giao dịch"
    Write-Host "  • Tất cả người tham gia cần private keys để ký"
    Write-Host "  • Xóa các file tạm sau khi chuyển vào lưu trữ an toàn`n"
    
    Write-Host "✓ Dùng multisig.addr để nhận ADA (cần 2-trong-2 chữ ký để chi tiêu)"
    Write-Host "✓ Mỗi người có thể dùng .payment.addr để giao dịch cá nhân (1 chữ ký)`n"
}

# Main execution flow with navigation
$currentStep = 0  # Start from 0 (initialize/welcome screen)
$maxStep = 5      # Now we have 5 actual steps
$completed = $false

while (-not $completed) {
    $success = $false
    
    switch ($currentStep) {
        0 { $success = Step-Initialize }
        1 { $success = Step-SelectNetwork }
        2 { $success = Step-SetupParticipants }
        3 { $success = Step-DeriveKeys }
        4 { $success = Step-ConfigurePolicy }
        5 { $success = Step-GenerateAddress }
    }
    
    if (-not $success) {
        Write-Host ("`n" + ((Get-Text "stepFailed") -f $currentStep)) -ForegroundColor Red
        $retry = Prompt-YesNo (Get-Text "retryStep") $true
        if (-not $retry) { break }
        continue
    }
    
    # Show navigation menu after successful step (skip for step 0 - Initialize)
    if ($currentStep -eq 0) {
        $currentStep++
        continue
    }
    
    $stepNames = if ($script:lang -eq "vi") {
        @("Chọn Network", "Thiết Lập Người Tham Gia", "Tạo Keys", 
          "Cấu Hình Policy", "Tạo Address")
    } else {
        @("Select Network", "Setup Participants", "Derive Keys", 
          "Configure Policy", "Generate Address")
    }
    $nav = Show-StepMenu $stepNames[$currentStep - 1] $currentStep
    
    switch ($nav.action) {
        'continue' { 
            if ($currentStep -eq $maxStep) {
                $completed = $true
            } else {
                $currentStep++
            }
        }
        'redo' { 
            # Stay at current step (will loop and redo)
        }
        'back' { 
            if ($currentStep -gt 1) {
                $currentStep--
            } else {
                Write-Host (Get-Text "alreadyFirstStep") -ForegroundColor Yellow
            }
        }
        'goto' {
            if ($nav.step -ge 1 -and $nav.step -le $maxStep) {
                $currentStep = $nav.step
            } else {
                Write-Host (Get-Text "invalidStepNumber") -ForegroundColor Yellow
            }
        }
        'quit' {
            Write-Host (Get-Text "quitting") -ForegroundColor Red
            exit 0
        }
    }
}

# Final summary
Write-Host "`n╔════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host ("║  " + (Get-Text "completedTitle").PadRight(66) + "║") -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════════════╝" -ForegroundColor Green

Write-Host ("`n" + (Get-Text "filesCreated")) -ForegroundColor Yellow

# Show participant files
foreach ($participant in $script:participants) {
    Write-Host ("`n" + ((Get-Text "participantFiles") -f $participant.Name, $participant.Name)) -ForegroundColor Cyan
    Write-Host ((Get-Text "file1") -f $participant.Name)
    Write-Host ((Get-Text "file2") -f $participant.Name)
    Write-Host ((Get-Text "file3") -f $participant.Name, $script:paymentIndex)
    Write-Host ((Get-Text "file4") -f $participant.Name, $script:paymentIndex)
    Write-Host ((Get-Text "file5") -f $participant.Name)
    if ($participant.PaymentAddr) {
        Write-Host ((Get-Text "file6") -f $participant.Name)
        Write-Host "     $($participant.PaymentAddr)" -ForegroundColor Gray
    }
}

# Show policy files
Write-Host ("`n" + (Get-Text "policyFiles")) -ForegroundColor Cyan
Write-Host (Get-Text "file7")
Write-Host (Get-Text "file8")
Write-Host (Get-Text "file9")

Write-Host ("`n" + (Get-Text "securityNotesTitle")) -ForegroundColor Red
Write-Host (Get-Text "secNote1")
Write-Host (Get-Text "secNote2")
Write-Host ((Get-Text "secNote3") -f $script:threshold)
Write-Host (Get-Text "secNote4")
Write-Host (Get-Text "secNote5")
Write-Host ""
Write-Host ((Get-Text "useMultisigAddr") -f $script:threshold, $script:participantCount) -ForegroundColor Green
Write-Host (Get-Text "useIndividualAddr") -ForegroundColor Green
