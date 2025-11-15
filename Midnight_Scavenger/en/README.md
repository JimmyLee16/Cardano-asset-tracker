## 🧰 Midnight-Scavenger Address Checker

- A small tool that helps check a list of wallet addresses through the **Midnight API**.  
Supports two input methods — manual entry or importing from a `.csv` file.  
- Created by **VCC Pool** for community purposes.

---

## 📦 Preparation

1. Download **2 files**: `Checksolution_gui(vie).ps1` and `checker.bat` (you can rename them, but make sure to update the `.ps1` filename inside the `.bat` file accordingly, e.g. `check_addresses.ps1` and `run_check.bat`).  
2. Place both files in the **same directory**.

---

## ⚙️ How to Use

Run the `.bat` file to start the tool.

### Method 1 — Using a CSV file
1. Create a file named `address_list.csv` in the same folder as the two script files.  
2. The CSV file **must** have a header `Address` in column A, and subsequent rows should contain the wallet addresses you want to check.

**Example `address_list.csv`:**
Address
addr1q...
addr1z...
addr1xy...

yaml
Copy code

### Method 2 — Manual input
- Run `run_check.bat` (or execute `check_addresses.ps1` directly in PowerShell) — the script will prompt you to enter wallet addresses one by one in the CMD/PowerShell window.

---

## 🔄 How It Works

- The tool calls the **Midnight API** to check each address.  
- Currently, the tool **continuously calls the API** while scanning the list — for long lists, this may cause errors due to API rate limits or timeouts.  
- There is **no detailed log system yet** for failed addresses (to be added in future updates).

---

## ⚠️ Safety & Usage Notes

- **Manually review** `check_addresses.ps1` and `run_check.bat` before running — they execute directly in CMD/PowerShell.  
- If you have a **large list**, split it into smaller CSV files (e.g., 50–100 addresses per file) to avoid rate-limit issues.  
- Do **not** use this tool for illegal purposes or actions that may overload the API.

---

## 🧩 Roadmap (Planned)

- v1.0 — Read from CSV / Manual input — **Completed**  
- v1.1 — Add logging for failed address checks — **Planned**  
- v1.2 — Add API throttling/limiting (delay, retry) — **Planned**

---

## 🛠 Example Commands

**PowerShell (run the script directly):**
```powershell
# Open PowerShell → navigate to the folder → run:
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass 
./check_addresses.ps1

CMD (using .bat file):

cmd
Copy code
cd C:\path\to\folder
run_check.bat

⚖️ Disclaimer
This tool is provided free of charge and intended solely for educational and API testing purposes.

The author is not responsible for any damages, data loss, or misuse.

Users are fully responsible for executing scripts on their own systems.

No guarantee is provided for the accuracy, stability, or uptime of the Midnight API used in this tool.

By using this tool, you agree to the above terms of disclaimer.

📞 Contact
Cardano ADA Vietnam Telegram Group: https://t.me/ADA_VIET

📜 License
MIT License © 2025
