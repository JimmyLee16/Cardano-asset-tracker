<#
PowerShell Manual Cardano-Address Flow with Interactive Navigation
Bilingual Support: English & Vietnamese
- Generates or uses an existing mnemonic (phrase.prv) or manually inputs
- Derives root, payment, and stake keys
- Builds payment address, stake address, and delegated/base address
- User can confirm, redo, or go back to previous steps after each operation

USAGE:
- Place this script in the same folder as your cardano-address executable.
- Run PowerShell and execute: .\manual.ps1
- IMPORTANT: This script writes private keys to disk. Handle them securely and delete when done.
#>
param(
    [switch]$ForceGenerate,
    [switch]$UseTestnet
)

# Ensure working dir = folder containing this script/exe
try {
    $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
    if ($scriptPath) { Set-Location -Path $scriptPath }
} catch { }

# Language selection
Write-Host "╔════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║           Cardano Address Generator - Language Selection          ║" -ForegroundColor Cyan
Write-Host "║           Tạo Địa Chỉ Cardano - Chọn Ngôn Ngữ                     ║" -ForegroundColor Cyan
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
        menuGoto = "[G] Go to specific step (1-6)"
        menuQuit = "[Q] Quit"
        menuPrompt = "Enter choice"
        stepCompleted = "Step {0}: {1} - Completed"
        whatNext = "What would you like to do next?"
        
        # Step 0: Initialize
        welcomeTitle = "Cardano Address Generator - Interactive Flow"
        usageGuide = "USAGE GUIDE:"
        usageDesc = "  • This script will guide you through 6 steps to create Cardano addresses"
        usageNav = "  • After each step, you can:"
        usageNav1 = "    - Continue to next step"
        usageNav2 = "    - Redo current step"
        usageNav3 = "    - Go back to previous step"
        usageNav4 = "    - Jump to specific step"
        stepsTitle = "STEPS:"
        step1Desc = "  1. Select network (mainnet/testnet)"
        step2Desc = "  2. Setup mnemonic phrase (seed words)"
        step3Desc = "  3. Setup passphrase (optional)"
        step4Desc = "  4. Create root key from mnemonic"
        step5Desc = "  5. Create payment key and address"
        step6Desc = "  6. Create stake key and delegated address"
        securityTitle = "⚠️  SECURITY IMPORTANT:"
        security1 = "  • This script creates files containing private keys"
        security2 = "  • Keep these files safe and DO NOT share"
        security3 = "  • Delete temporary files after use"
        security4 = "  • Passphrase is NOT saved to disk"
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
        
        # Step 2: Mnemonic
        step2Title = "STEP 2: Setup Mnemonic"
        phraseExists = "phrase.prv exists. Use existing file? (No = generate new)"
        usingExisting = "Using existing {0}"
        chooseMnemonic = "Choose how to set mnemonic:"
        mnemonicManual = "  1) manual - enter mnemonic manually"
        mnemonicAuto = "  2) auto   - generate new mnemonic"
        mnemonicFile = "  3) file   - use another existing file"
        mnemonicChoice = "Enter choice (manual/auto/file)"
        enterMnemonic = "Enter mnemonic words separated by space"
        mnemonicStored = "Mnemonic stored in variable."
        enterWordCount = "Enter number of words (9,12,15,18,21,24)"
        generatingMnemonic = "Generating mnemonic and saving to {0}..."
        failedGenerate = "Failed to generate mnemonic."
        mnemonicSaved = "Mnemonic saved to {0}"
        enterFilePath = "Enter path to existing mnemonic file"
        copiedMnemonic = "Copied mnemonic from {0}"
        fileNotFound = "File not found: {0}"
        invalidChoice = "Invalid choice."
        
        # Step 3: Passphrase
        step3Title = "STEP 3: Setup Passphrase"
        passphraseInfo = "If you want an empty passphrase press Enter. Otherwise type a passphrase."
        enterPassphrase = "Enter passphrase (hidden)"
        emptyPassphrase = "Empty passphrase will be used."
        passphraseSet = "Passphrase set (not saved to disk)."
        
        # Step 4: Root Key
        step4Title = "STEP 4: Create Root Key"
        failedRoot = "Failed to create root.xsk."
        rootCreated = "root.xsk created successfully."
        
        # Step 5: Payment Key
        step5Title = "STEP 5: Create Payment Key and Address"
        enterPayIndex = "Enter index number for payment key (0 -> 2^31-1)"
        derivingPayment = "Deriving payment private key (path: {0})..."
        failedPaymentKey = "Failed to derive addr.xsk"
        exportingPaymentPub = "Exporting payment public key..."
        failedPaymentPub = "Failed to export addr.xvk"
        buildingPaymentAddr = "Building payment address..."
        failedPaymentAddr = "Failed to build payment.addr"
        paymentCreated = "Payment key and address created successfully."
        paymentAddress = "Payment Address: {0}"
        
        # Step 6: Stake Key
        step6Title = "STEP 6: Create Stake Key and Delegated Address"
        enterStakeIndex = "Enter index number for stake key (0 -> 2^31-1)"
        derivingStake = "Deriving stake private key (path: {0})..."
        failedStakeKey = "Failed to derive stake.xsk"
        exportingStakePub = "Exporting stake public key..."
        failedStakePub = "Failed to export stake.xvk"
        buildingStakeAddr = "Building stake address..."
        failedStakeAddr = "Failed to build stake.addr (non-fatal)"
        stakeAddrCreated = "Stake address created."
        buildingDelegated = "Building delegated/base address..."
        stakeEmpty = "stake.xvk is empty"
        failedDelegated = "Failed to build addr.delegated"
        stakeCreated = "Stake key and delegated address created successfully."
        stakeAddress = "Stake Address: {0}"
        delegatedAddress = "Delegated Address: {0}"
        
        # Final
        completedTitle = "COMPLETED - ADDRESS CREATION"
        filesCreated = "Files created in current folder:"
        file1 = "  📄 phrase.prv      - Mnemonic phrase (seed words)"
        file2 = "  🔐 root.xsk        - Root private key"
        file3 = "  🔐 addr.xsk        - Payment private key"
        file4 = "  🔓 addr.xvk        - Payment public key"
        file5 = "  💳 payment.addr    - Payment address"
        file6 = "  🔐 stake.xsk       - Stake private key"
        file7 = "  🔓 stake.xvk       - Stake public key"
        file8 = "  🎯 stake.addr      - Stake address"
        file9 = "  ⭐ addr.delegated  - Delegated/base address (use this to receive ADA)"
        securityNotesTitle = "⚠️  SECURITY NOTES:"
        secNote1 = "  • .xsk files contain private keys - NEVER share them"
        secNote2 = "  • Backup phrase.prv and passphrase securely (if used)"
        secNote3 = "  • Delete temporary files after moving to secure wallet"
        secNote4 = "  • Do not store private keys on internet-connected computers"
        useDelegated = "✓ Use delegated address (addr.delegated) to receive ADA"
        
        # Errors
        stepFailed = "Step {0} failed. Please try again."
        retryStep = "Retry this step?"
        alreadyFirstStep = "Already at first step."
        invalidStepNumber = "Invalid step number. Staying at current step."
        quitting = "Quitting..."
        gotoPrompt = "Enter step number (1-6)"
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
        menuGoto = "[G] Nhảy đến bước cụ thể (1-6)"
        menuQuit = "[Q] Thoát"
        menuPrompt = "Nhập lựa chọn"
        stepCompleted = "Bước {0}: {1} - Hoàn thành"
        whatNext = "Bạn muốn làm gì tiếp theo?"
        
        # Step 0: Initialize
        welcomeTitle = "Tạo Địa Chỉ Cardano - Hướng Dẫn Tương Tác"
        usageGuide = "HƯỚNG DẪN SỬ DỤNG:"
        usageDesc = "  • Script này sẽ hướng dẫn bạn tạo địa chỉ Cardano qua 6 bước"
        usageNav = "  • Sau mỗi bước, bạn có thể:"
        usageNav1 = "    - Tiếp tục bước tiếp theo"
        usageNav2 = "    - Làm lại bước hiện tại"
        usageNav3 = "    - Quay lại bước trước để chỉnh sửa"
        usageNav4 = "    - Nhảy đến bước cụ thể"
        stepsTitle = "CÁC BƯỚC THỰC HIỆN:"
        step1Desc = "  1. Chọn network (mainnet/testnet)"
        step2Desc = "  2. Thiết lập mnemonic phrase (seed words)"
        step3Desc = "  3. Thiết lập passphrase (tùy chọn)"
        step4Desc = "  4. Tạo root key từ mnemonic"
        step5Desc = "  5. Tạo payment key và address"
        step6Desc = "  6. Tạo stake key và delegated address"
        securityTitle = "⚠️  BẢO MẬT QUAN TRỌNG:"
        security1 = "  • Script này tạo các file chứa private keys"
        security2 = "  • Giữ các file này an toàn và KHÔNG chia sẻ"
        security3 = "  • Xóa các file tạm sau khi sử dụng xong"
        security4 = "  • Passphrase không được lưu vào disk"
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
        
        # Step 2: Mnemonic
        step2Title = "BƯỚC 2: Thiết Lập Mnemonic"
        phraseExists = "phrase.prv đã tồn tại. Sử dụng file hiện có? (Không = tạo mới)"
        usingExisting = "Đang sử dụng file hiện có {0}"
        chooseMnemonic = "Chọn cách thiết lập mnemonic:"
        mnemonicManual = "  1) manual - nhập mnemonic thủ công"
        mnemonicAuto = "  2) auto   - tạo mnemonic mới tự động"
        mnemonicFile = "  3) file   - sử dụng file khác đã có"
        mnemonicChoice = "Nhập lựa chọn (manual/auto/file)"
        enterMnemonic = "Nhập các từ mnemonic cách nhau bởi dấu cách"
        mnemonicStored = "Mnemonic đã lưu vào biến."
        enterWordCount = "Nhập số lượng từ (9,12,15,18,21,24)"
        generatingMnemonic = "Đang tạo mnemonic và lưu vào {0}..."
        failedGenerate = "Không thể tạo mnemonic."
        mnemonicSaved = "Mnemonic đã lưu vào {0}"
        enterFilePath = "Nhập đường dẫn đến file mnemonic hiện có"
        copiedMnemonic = "Đã sao chép mnemonic từ {0}"
        fileNotFound = "Không tìm thấy file: {0}"
        invalidChoice = "Lựa chọn không hợp lệ."
        
        # Step 3: Passphrase
        step3Title = "BƯỚC 3: Thiết Lập Passphrase"
        passphraseInfo = "Nếu muốn passphrase trống, nhấn Enter. Ngược lại, nhập passphrase."
        enterPassphrase = "Nhập passphrase (ẩn)"
        emptyPassphrase = "Sẽ sử dụng passphrase trống."
        passphraseSet = "Đã thiết lập passphrase (không lưu vào disk)."
        
        # Step 4: Root Key
        step4Title = "BƯỚC 4: Tạo Root Key"
        failedRoot = "Không thể tạo root.xsk."
        rootCreated = "root.xsk đã tạo thành công."
        
        # Step 5: Payment Key
        step5Title = "BƯỚC 5: Tạo Payment Key và Address"
        enterStakeAccountIndex = "Nhập số index cho stake account (0 -> 2^31-1)"
        enterPayIndex = "Nhập số index cho payment key (0 -> 2^31-1)"
        derivingPayment = "Đang tạo payment private key (đường dẫn: {0})..."
        failedPaymentKey = "Không thể tạo addr.xsk"
        exportingPaymentPub = "Đang xuất payment public key..."
        failedPaymentPub = "Không thể xuất addr.xvk"
        buildingPaymentAddr = "Đang tạo payment address..."
        failedPaymentAddr = "Không thể tạo payment.addr"
        paymentCreated = "Payment key và address đã tạo thành công."
        paymentAddress = "Payment Address: {0}"
        
        # Step 6: Stake Key
        step6Title = "BƯỚC 6: Tạo Stake Key và Delegated Address"
        enterStakeIndex = "Nhập số index cho stake key (0 -> 2^31-1)"
        derivingStake = "Đang tạo stake private key (đường dẫn: {0})..."
        failedStakeKey = "Không thể tạo stake.xsk"
        exportingStakePub = "Đang xuất stake public key..."
        failedStakePub = "Không thể xuất stake.xvk"
        buildingStakeAddr = "Đang tạo stake address..."
        failedStakeAddr = "Không thể tạo stake.addr (không nghiêm trọng)"
        stakeAddrCreated = "Stake address đã tạo."
        buildingDelegated = "Đang tạo delegated/base address..."
        stakeEmpty = "stake.xvk trống"
        failedDelegated = "Không thể tạo addr.delegated"
        stakeCreated = "Stake key và delegated address đã tạo thành công."
        stakeAddress = "Stake Address: {0}"
        delegatedAddress = "Delegated Address: {0}"
        
        # Final
        completedTitle = "HOÀN THÀNH TẠO ADDRESS"
        filesCreated = "Các file đã tạo trong thư mục hiện tại:"
        file1 = "  📄 phrase.prv      - Mnemonic phrase (seed words)"
        file2 = "  🔐 root.xsk        - Root private key"
        file3 = "  🔐 addr.xsk        - Payment private key"
        file4 = "  🔓 addr.xvk        - Payment public key"
        file5 = "  💳 payment.addr    - Payment address"
        file6 = "  🔐 stake.xsk       - Stake private key"
        file7 = "  🔓 stake.xvk       - Stake public key"
        file8 = "  🎯 stake.addr      - Stake address"
        file9 = "  ⭐ addr.delegated  - Delegated/base address (dùng để nhận ADA)"
        securityNotesTitle = "⚠️  LƯU Ý BẢO MẬT:"
        secNote1 = "  • Các file .xsk chứa private keys - TUYỆT ĐỐI KHÔNG chia sẻ"
        secNote2 = "  • Sao lưu phrase.prv và passphrase an toàn (nếu có)"
        secNote3 = "  • Xóa các file tạm sau khi chuyển vào ví an toàn"
        secNote4 = "  • Không lưu private keys trên máy tính kết nối internet"
        useDelegated = "✓ Địa chỉ delegated (addr.delegated) dùng để nhận ADA"
        
        # Errors
        stepFailed = "Bước {0} thất bại. Vui lòng thử lại."
        retryStep = "Thử lại bước này?"
        alreadyFirstStep = "Đã ở bước đầu tiên."
        invalidStepNumber = "Số bước không hợp lệ. Ở lại bước hiện tại."
        quitting = "Đang thoát..."
        gotoPrompt = "Nhập số bước (1-6)"
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
    Write-Host (Get-Text "step6Desc")
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
    Write-Host ""
    
    $null = Read-Host (Get-Text "pressStart")
    return $true
}

function Step-SelectNetwork {
    Write-Host ("`n=== " + (Get-Text "step1Title") + " ===") -ForegroundColor Cyan
    
    if ($script:UseTestnet) {
        $script:networkTag = "testnet"
    } else {
        $isTest = Prompt-YesNo (Get-Text "useTestnet") $false
        $script:networkTag = if ($isTest) { "testnet" } else { "mainnet" }
    }
    Write-Host ((Get-Text "selectNetwork") -f $script:networkTag) -ForegroundColor Green
    return $true
}

function Step-SetupMnemonic {
    Write-Host ("`n=== " + (Get-Text "step2Title") + " ===") -ForegroundColor Cyan
    
    $phraseFile = ".\phrase.prv"
    $script:mnemonic = $null

    if (-not $script:ForceGenerate -and (Test-Path $phraseFile)) {
        $useExisting = Prompt-YesNo (Get-Text "phraseExists") $true
        if ($useExisting) {
            Write-Host ((Get-Text "usingExisting") -f $phraseFile) -ForegroundColor Green
            return $true
        }
    }

    Write-Host (Get-Text "chooseMnemonic")
    Write-Host (Get-Text "mnemonicManual")
    Write-Host (Get-Text "mnemonicAuto")
    Write-Host (Get-Text "mnemonicFile")
    $choice = Read-Host (Get-Text "mnemonicChoice")

    switch ($choice) {
        "manual" {
            $script:mnemonic = Read-Host (Get-Text "enterMnemonic")
            Write-Host (Get-Text "mnemonicStored") -ForegroundColor Green
        }
        "auto" {
            $size = Read-Host (Get-Text "enterWordCount")
            Write-Host ((Get-Text "generatingMnemonic") -f $phraseFile)
            & $script:cardanoExe recovery-phrase generate --size $size > $phraseFile
            if ($LASTEXITCODE -ne 0) {
                Write-Error (Get-Text "failedGenerate")
                return $false
            }
            Write-Host ((Get-Text "mnemonicSaved") -f $phraseFile) -ForegroundColor Green
        }
        "file" {
            $srcFile = Read-Host (Get-Text "enterFilePath")
            if (Test-Path $srcFile) {
                Copy-Item $srcFile $phraseFile -Force
                Write-Host ((Get-Text "copiedMnemonic") -f $srcFile) -ForegroundColor Green
            } else {
                Write-Error ((Get-Text "fileNotFound") -f $srcFile)
                return $false
            }
        }
        default {
            Write-Error (Get-Text "invalidChoice")
            return $false
        }
    }
    return $true
}

function Step-SetupPassphrase {
    Write-Host ("`n=== " + (Get-Text "step3Title") + " ===") -ForegroundColor Cyan
    Write-Host (Get-Text "passphraseInfo")
    
    $securePass = Read-Host (Get-Text "enterPassphrase") -AsSecureString
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePass)
    try {
        $script:passPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($BSTR)
    } finally {
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
    }
    
    if ([string]::IsNullOrEmpty($script:passPlain)) {
        Write-Host (Get-Text "emptyPassphrase") -ForegroundColor Green
    } else {
        Write-Host (Get-Text "passphraseSet") -ForegroundColor Green
    }
    return $true
}

function Step-CreateRootKey {
    Write-Host ("`n=== " + (Get-Text "step4Title") + " ===") -ForegroundColor Cyan
    
    if ($null -ne $script:mnemonic -and $script:mnemonic.Trim().Length -gt 0) {
        $phraseContent = $script:mnemonic.Trim()
    } else {
        $phraseContent = Get-Content .\phrase.prv -Raw
    }

    $inputForRoot = $phraseContent + "`n" + $script:passPlain
    $inputForRoot | & $script:cardanoExe key from-recovery-phrase Shelley > .\root.xsk
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error (Get-Text "failedRoot")
        return $false
    }
    Write-Host (Get-Text "rootCreated") -ForegroundColor Green
    return $true
}

function Step-DerivePaymentKey {
    Write-Host ("`n=== " + (Get-Text "step5Title") + " ===") -ForegroundColor Cyan
    
    # Get stake index first
    $script:stakeIndex = Read-Host (Get-Text "enterStakeAccountIndex")
    if ([string]::IsNullOrWhiteSpace($script:stakeIndex)) {
        $script:stakeIndex = "0"
    }
    
    # Then get payment index
    $script:payIndex = Read-Host (Get-Text "enterPayIndex")
    $payPath = "1852H/1815H/$($script:stakeIndex)H/0/$($script:payIndex)"
    
    Write-Host ((Get-Text "derivingPayment") -f $payPath)
    Get-Content .\root.xsk -Raw | & $script:cardanoExe key child $payPath > .\addr.xsk
    if ($LASTEXITCODE -ne 0) { 
        Write-Error (Get-Text "failedPaymentKey")
        return $false
    }
    
    Write-Host (Get-Text "exportingPaymentPub")
    Get-Content .\addr.xsk -Raw | & $script:cardanoExe key public --without-chain-code > .\addr.xvk
    if ($LASTEXITCODE -ne 0) { 
        Write-Error (Get-Text "failedPaymentPub")
        return $false
    }
    
    Write-Host (Get-Text "buildingPaymentAddr")
    Get-Content .\addr.xvk -Raw | & $script:cardanoExe address payment --network-tag $script:networkTag > .\payment.addr
    if ($LASTEXITCODE -ne 0) { 
        Write-Error (Get-Text "failedPaymentAddr")
        return $false
    }
    
    Write-Host (Get-Text "paymentCreated") -ForegroundColor Green
    Write-Host ((Get-Text "paymentAddress") -f (Get-Content .\payment.addr -Raw)) -ForegroundColor Yellow
    return $true
}

function Step-DeriveStakeKey {
    Write-Host ("`n=== " + (Get-Text "step6Title") + " ===") -ForegroundColor Cyan
    
    $script:stakeIndex = Read-Host (Get-Text "enterStakeIndex")
    $stakePath = "1852H/1815H/0H/2/$($script:stakeIndex)"
    
    Write-Host ((Get-Text "derivingStake") -f $stakePath)
    Get-Content .\root.xsk -Raw | & $script:cardanoExe key child $stakePath > .\stake.xsk
    if ($LASTEXITCODE -ne 0) { 
        Write-Error (Get-Text "failedStakeKey")
        return $false
    }
    
    Write-Host (Get-Text "exportingStakePub")
    Get-Content .\stake.xsk -Raw | & $script:cardanoExe key public --without-chain-code > .\stake.xvk
    if ($LASTEXITCODE -ne 0) { 
        Write-Error (Get-Text "failedStakePub")
        return $false
    }
    
    Write-Host (Get-Text "buildingStakeAddr")
    Get-Content .\stake.xvk -Raw | & $script:cardanoExe address stake --network-tag $script:networkTag > .\stake.addr
    if ($LASTEXITCODE -ne 0) { 
        Write-Warning (Get-Text "failedStakeAddr")
    } else {
        Write-Host (Get-Text "stakeAddrCreated")
    }
    
    Write-Host (Get-Text "buildingDelegated")
    $stakePub = (Get-Content .\stake.xvk -Raw).Trim()
    if (-not $stakePub) { 
        Write-Error (Get-Text "stakeEmpty")
        return $false
    }
    Get-Content .\payment.addr -Raw | & $script:cardanoExe address delegation $stakePub > .\addr.delegated
    if ($LASTEXITCODE -ne 0) { 
        Write-Error (Get-Text "failedDelegated")
        return $false
    }
    
    Write-Host (Get-Text "stakeCreated") -ForegroundColor Green
    Write-Host ((Get-Text "stakeAddress") -f (Get-Content .\stake.addr -Raw)) -ForegroundColor Yellow
    Write-Host ((Get-Text "delegatedAddress") -f (Get-Content .\addr.delegated -Raw)) -ForegroundColor Yellow
    return $true
}

# Main execution flow with navigation
$currentStep = 0  # Start from 0 (initialize/welcome screen)
$maxStep = 6      # Now we have 6 actual steps
$completed = $false

while (-not $completed) {
    $success = $false
    
    switch ($currentStep) {
        0 { $success = Step-Initialize }
        1 { $success = Step-SelectNetwork }
        2 { $success = Step-SetupMnemonic }
        3 { $success = Step-SetupPassphrase }
        4 { $success = Step-CreateRootKey }
        5 { $success = Step-DerivePaymentKey }
        6 { $success = Step-DeriveStakeKey }
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
        @("Chọn Network", "Thiết Lập Mnemonic", "Thiết Lập Passphrase", 
          "Tạo Root Key", "Tạo Payment Key", "Tạo Stake Key")
    } else {
        @("Select Network", "Setup Mnemonic", "Setup Passphrase", 
          "Create Root Key", "Create Payment Key", "Create Stake Key")
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
Write-Host (Get-Text "file1")
Write-Host (Get-Text "file2")
Write-Host (Get-Text "file3")
Write-Host (Get-Text "file4")
Write-Host (Get-Text "file5")
Write-Host (Get-Text "file6")
Write-Host (Get-Text "file7")
Write-Host (Get-Text "file8")
Write-Host (Get-Text "file9")

# Cleanup passphrase from memory
if ($passPlain) {
    $passPlain = $null
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
}

Write-Host ("`n" + (Get-Text "securityNotesTitle")) -ForegroundColor Red
Write-Host (Get-Text "secNote1")
Write-Host (Get-Text "secNote2")
Write-Host (Get-Text "secNote3")
Write-Host (Get-Text "secNote4")
Write-Host ""
Write-Host (Get-Text "useDelegated") -ForegroundColor Green
