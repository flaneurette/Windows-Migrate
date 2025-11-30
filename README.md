# Windows (10/11+) Migration Script

A **one-click FULL Windows migration and restore toolkit** in a single batch file.  

This script allows you to **backup and restore user data, system settings, and installed programs** between Windows PCs, making migration simple, safe, and mostly automated.

## Installation

### On the old Windows PC:
1. Copy the `Migrate` folder to your **Desktop**. Follow these steps **in order**
2. As **administrator**, right-click `Migrate/Export/ExportWindowsSettings.bat` to export all Windows settings.
3. As **administrator**, right-click `Migrate/Export/CopyUserData.bat` to export user data (backup AppData & Desktop to external disk).

**Note**: After running these scripts, be sure that you copy the /Migrate/ folder from the old PC's Desktop to the new PC's Desktop. 
(The CopyUserData.bat script also copies the entire desktop on your old PC to your external drive, so on the new PC you should copy the /Migrate/folder from the external backup to your new desktop!)
Then proceed..

### On the new Windows PC:
1. Copy the `Migrate` folder (from external backup) to your **Desktop** . Then, follow these steps **in order** for maximum safety:
2. As **administrator**, right-click `Migrate/Install/InstallFirewall.bat` to restore firewall rules.
3. As **administrator**, right-click `Migrate/Install/ImportHosts.bat` to restore hosts file (it also makes a backup of current one).
4. As **administrator**, right-click `Migrate/Install/ImportWifi.bat` to restore Wi-Fi profiles.
5. As **administrator**, right-click `Migrate/Install/ImportPath.bat` to restore the PATH environment variable.
6. As **administrator**, right-click `Migrate/Install/InstallSoftware.bat` to install all exported software (using winget)
7. As **administrator**, right-click `Migrate/Install/InstallSoftwareWOW64.bat` to install all exported WOW64 software (using winget)
8. Manually copy your exported /AppData/ folder (from external drive) to the new PC.
9. As **administrator**, right-click `Migrate/Install/ImportBrowserData.bat` to restore browser profiles.
10. Extra: As **administrator**, right-click `Migrate/Install/InstallNextDNS.bat` to set the DNS servers to NextDNS, and optionally download NextDNS software! (optional, recommended)
    
All software should now continue where you left of! enjoy!

**Notes:**
- Other files and settings do not have BAT installation scripts and require **manual installation or transfer** due to security and reliability reasons. These are: Registry hives HKLM, HKCU, HKCR, HKU, HKCC, Drivers, services, printers, startup programs, scheduled tasks, Windows activation status and restore points. These are included in the backup, in case you ever need them. If so, manually extract these items, if so desired.
- Upon software installation: The software guesses installed software names for winget. The install software program is therefore interactive, and lists possible package candidates, and then asks the user to select an option for each package to install, as winget hosts many versions i.e. different packages! Installation of software with winget is quick, faster than manually downloading and installing. So we recommend using it!
- There is also a `Migrate/Install/Checksums.bat` file, which can be used to verify newly installed/downloaded software. It scans the `/Downloads/` folder and generates checksums if desired.
- If you haven't hardened your Windows Firewall yet, you can do so with this extra powershell script (highly recommended):
<a href="https://github.com/flaneurette/Harden-Windows-OS-Firewall">https://github.com/flaneurette/Harden-Windows-OS-Firewall</a>

## Features

### Backup / Export
- Exports Windows product key to /Keys/ if it exists. (does not work on digital license!)
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
- Install all exported software automatically with winget

---

## Requirements

- **Windows 10 or 11+**
- **Administrator privileges** for some steps (Registry, Firewall, Wi-Fi)
- Optional: **7-Zip** for faster and more reliable ZIP compression
- Enough diskspace. The registry export can take up 500MB+ and a Chrome user Folder 2GB+. Prepare at least 5GB of free space!
- Winget, to install new software automatically on the new PC.
  
  **To install winget on new PC**
  
  - Option 1: open the Microsoft Store and locate: "App Installer" or "Winget", and install it if you don't have it. 
  Permalink: https://apps.microsoft.com/detail/9nblggh4nns1
  - Option 2: Download winget manually: https://aka.ms/getwinget
  - Then, in powershell navigate to the /Downloads/ folder and (as admin) type:
    
    ```Add-AppxPackage -Path Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle```

---

## Safety Notes

- **Registry imports**: Only safe keys (like HKCU) are recommended. Be careful with HKLM/HKCC. The script just makes a backup of the ENTIRE registry, it is not recommended to import it as such! Thus, there is no .bat file to do this. Only do it manually if you are SURE that nothing will break! especially on different windows platforms. **You are hereby forewarned.**
- **Browser profiles**: Chrome, Edge, Firefox must be **closed** during restore.  
- **Wi-Fi & Firewall**: Admin rights required. Backups of current configurations are automatically created.  
- The script uses **interactive prompts** to prevent accidental overwrites. 

---

## License

[MIT License](LICENSE) – free to use and modify.





