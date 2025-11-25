# Windows Migration Script

A **one-click Windows migration and restore toolkit** in a single batch file.  

This script allows you to **backup and restore user data, system settings, and installed programs** between Windows PCs, making migration simple, safe, and mostly automated.

## Installation

### On the old Windows PC:
1. Copy the `Migrate` folder to your **Desktop**.
2. As **administrator**, right-click `Migrate/Export/ExportWindowsSettings.bat` to export all Windows settings.
3. As **administrator**, right-click `Migrate/Export/CopyUserData.bat` to export user data (backup).

### On the new Windows PC:
1. Copy the `Migrate` folder to your **Desktop**.
2. As **administrator**, right-click `Migrate/Install/InstallFirewall.bat` to restore firewall rules.
3. As **administrator**, right-click `Migrate/Install/ImportWifi.bat` to restore Wi-Fi profiles.
4. As **administrator**, right-click `Migrate/Install/ImportPath.bat` to restore the PATH environment variable.
5. As **administrator**, right-click `Migrate/Install/InstallSoftware.bat` to install software using Winget (required for automated program installation).
6. As **administrator**, right-click `Migrate/Install/ImportBrowserData.bat` to restore browser profiles.

**Notes:**
- Other files and settings do not have BAT scripts and require **manual installation or transfer** due to security and reliability reasons.  
- There is also a `Migrate/Install/Checksums.bat` file, which can be used to verify newly installed software. It scans the `/Downloads/` folder and generates checksums if desired.

---

## Features

### Backup / Export
- **User AppData** (optional, selective copying)
- **Desktop folders**
- **Browser profiles:** Chrome, Edge, Firefox
- Installed programs lists from **registry** (HKLM and Wow6432Node)
- User **PATH** environment variable
- **Wi-Fi profiles** (with passwords)
- **Firewall rules**
- **Registry hives:** HKLM, HKCU, HKCR, HKU, HKCC
- Drivers, services, printers, startup programs
- Scheduled tasks
- Hosts file
- Windows activation status and restore points
- Compresses all collected data into a **timestamped ZIP**
  - Uses **7-Zip** if installed, falls back to PowerShell `Compress-Archive` if not

### Restore / Import
- Interactive prompts before each step (`Press Enter to continue…`)
- Restore **Wi-Fi profiles**
- Restore **Browser profiles** (Chrome, Edge, Firefox)
- Restore **PATH** environment variable
- Restore **Firewall rules**
- Import **registry keys** (HKCU and optional others)
- Install programs automatically using **Winget** (silent install if available)

---

## Requirements

- **Windows 10 or 11**
- **Administrator privileges** for some steps (Registry, Firewall, Wi-Fi)
- Optional: **7-Zip** for faster and more reliable ZIP compression
- **Winget** for automated program installation

---

## Usage

### Backup (Old PC)

1. Download the script and run it as **administrator**.
2. Follow the prompts to backup data to: %USERPROFILE%\Desktop\Migrate\Data


3. A **timestamped ZIP** of all collected data will be created on the Desktop.

---

### Restore (New PC)

1. Copy the backup folder or ZIP to the new PC.
2. Run the script as **administrator**.
3. Follow **interactive prompts** to restore:
- Wi-Fi profiles
- Browser profiles
- PATH environment variable
- Firewall rules
- Programs via Winget
4. Logs are saved in: %USERPROFILE%\Desktop\Migrate\Data\Logs

---

## Safety Notes

- **Registry imports**: Only safe keys (like HKCU) are recommended. Be careful with HKLM/HKCC.  
- **Browser profiles**: Chrome, Edge, Firefox must be **closed** during restore.  
- **Wi-Fi & Firewall**: Admin rights required. Backups of current configurations are automatically created.  
- The script uses **interactive prompts** to prevent accidental overwrites. 

---

## License

[MIT License](LICENSE) – free to use and modify.





