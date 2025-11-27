# Windows (10/11+) Migration Script

A **one-click FULL Windows migration and restore toolkit** in a single batch file.  

This script allows you to **backup and restore user data, system settings, and installed programs** between Windows PCs, making migration simple, safe, and mostly automated.

## Installation

### On the old Windows PC:
1. Copy the `Migrate` folder to your **Desktop**.
2. As **administrator**, right-click `Migrate/Export/ExportWindowsSettings.bat` to export all Windows settings.
3. As **administrator**, right-click `Migrate/Export/CopyUserData.bat` to export user data (backup AppData & Desktop to external disk).

### On the new Windows PC:
1. Copy the `Migrate` folder to your **Desktop**. Then, follow these steps **in order** for maximum safety:
2. As **administrator**, right-click `Migrate/Install/InstallFirewall.bat` to restore firewall rules.
3. As **administrator**, right-click `Migrate/Install/ImportHosts.bat` to restore hosts file (it also makes a backup of current one).
4. As **administrator**, right-click `Migrate/Install/ImportWifi.bat` to restore Wi-Fi profiles.
5. As **administrator**, right-click `Migrate/Install/ImportPath.bat` to restore the PATH environment variable.
6. As **administrator**, right-click `Migrate/Install/ImportBrowserData.bat` to restore browser profiles.

**Notes:**
- Other files and settings do not have BAT installation scripts and require **manual installation or transfer** due to security and reliability reasons. These are: Registry hives HKLM, HKCU, HKCR, HKU, HKCC, Drivers, services, printers, startup programs, scheduled tasks, Windows activation status and restore points. These are included in the backup, in case you ever need them. If so, manually extract these items, if so desired.
- There is also a `Migrate/Install/Checksums.bat` file, which can be used to verify newly installed/downloaded software. It scans the `/Downloads/` folder and generates checksums if desired.

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

---

## Requirements

- **Windows 10 or 11+**
- **Administrator privileges** for some steps (Registry, Firewall, Wi-Fi)
- Optional: **7-Zip** for faster and more reliable ZIP compression
- **Winget** for automated program installation
- Enough diskspace. The registry export can take up 500MB+ and a Chrome user Folder 2GB+. Prepare at least 5GB of free space!
---

## Safety Notes

- **Registry imports**: Only safe keys (like HKCU) are recommended. Be careful with HKLM/HKCC. The script just makes a backup of the ENTIRE registry, it is not recommended to import it as such! Thus, there is no .bat file to do this. Only do it manually if you are SURE that nothing will break! especially on different windows platforms. **You are hereby forewarned.**
- **Browser profiles**: Chrome, Edge, Firefox must be **closed** during restore.  
- **Wi-Fi & Firewall**: Admin rights required. Backups of current configurations are automatically created.  
- The script uses **interactive prompts** to prevent accidental overwrites. 

---

## License

[MIT License](LICENSE) – free to use and modify.





