Here is an explanation of what the script does and instructions on how to set it up, including using Python virtual environments and handling potential PowerShell permission errors:

## README.md

### Chromium Password Recovery Script

This script retrieves and decrypts stored passwords from the Brave Browser. It utilizes Python and several libraries to access the browser's encrypted login data, decrypt it, and display the information.

#### Prerequisites

Before running the script, ensure you have the following installed:
- Python 3.x
- `pip` (Python package installer)
- `venv` (Python's built-in virtual environment module)
- Necessary Python libraries: `cryptography`, `pywin32`, `pysqlite3`

#### Setup Instructions

1. **Clone the Repository**

   Clone this repository to your local machine:
   ```sh
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Create a Virtual Environment**

   Set up a virtual environment to manage dependencies:
   ```sh
   python -m venv venv
   ```

   If you encounter a permission error in PowerShell, set the execution policy to allow script execution:
   ```sh
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

   Then activate the virtual environment:
   - On Windows (PowerShell):
     ```sh
     .\venv\Scripts\Activate
     ```
   - On Windows (Command Prompt):
     ```sh
     venv\Scripts\activate.bat
     ```

3. **Install Dependencies**

   Install the required Python libraries:
   ```sh
   pip install -r requirements.txt
   ```

   Create a `requirements.txt` file with the following content:
   ```
   cryptography
   pysqlite3
   pywin32
   ```

4. **Run the Script**

   Execute the script to retrieve and decrypt passwords:
   ```sh
   python possible_chromium_password_recovery.py
   ```

   The script will output URLs, usernames, and decrypted passwords stored in the Brave Browser.

### Script Explanation

This script performs the following steps:

1. **Retrieve the Encryption Key:**
   - Reads the `Local State` file of Brave Browser to get the encrypted key.
   - Decrypts the key using `win32crypt.CryptUnprotectData`.

2. **Decrypt Stored Passwords:**
   - Copies the `Login Data` SQLite database file to avoid conflicts.
   - Connects to the copied database and retrieves encrypted login details.
   - Decrypts the passwords using the retrieved encryption key and AES decryption.

3. **Output the Results:**
   - Prints the URLs, usernames, and decrypted passwords to the console.

### Potential Issues

- **PowerShell Execution Policy Error:**
  If you encounter a permission error when creating a virtual environment, run the following command in PowerShell to change the execution policy:
  ```sh
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```
  This allows PowerShell to run the activation script for the virtual environment.

- **Dependencies:**
  Ensure all dependencies listed in `requirements.txt` are correctly installed. If you encounter issues, try reinstalling or upgrading the problematic package.

---

By following these instructions, you should be able to set up and run the Chromium password recovery script successfully. If you have any questions or run into issues, feel free to open an issue in the repository.

# Define the path to the Brave Browser user data directory
$braveUserDataPath = "$env:USERPROFILE\AppData\Local\BraveSoftware\Brave-Browser\User Data\Default"

# Define the paths to the Login Data and Login Data.bak files
$loginDataPath = Join-Path -Path $braveUserDataPath -ChildPath "Login Data"
$loginDataBackupPath = Join-Path -Path $braveUserDataPath -ChildPath "Login Data.bak"

# Check if the Login Data.bak file exists
if (Test-Path -Path $loginDataBackupPath) {
    Write-Output "The backup file 'Login Data.bak' exists at path: $loginDataBackupPath"
} else {
    Write-Output "The backup file 'Login Data.bak' does not exist."
}
