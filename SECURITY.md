# Security Policy

Given that .bat files are inherently insecure, because they have file and system access, we cannot process security issues related to that fact.
Please only open issues if the .bat scripts are failing or not running as expected! this way, we can catch edge cases. Thank you.

## Supported Versions

Current version.

## Reporting a Vulnerability

Please open a issue on Github if you found a problem.

## Why `.bat` Files?

You might wonder: *“Why did you use batch files instead of an executable?”*

We chose `.bat` files intentionally for several reasons:

1. **Full transparency**  
   - Every command in a `.bat` file is readable. You can audit it line by line to see exactly what it does.  
   - With an `.exe`, all operations are hidden, so you would need reverse-engineering skills to verify safety.

2. **Safety first**  
   - `.bat` files cannot silently inject code, install hidden drivers, or persist in ways executables can.  
   - Even though they require admin privileges for some tasks, they do *only what you can see*.

3. **Cross-system compatibility**  
   - Batch files work natively on Windows 10 and 11 without any extra dependencies.  
   - You don’t need a compiler, installer, or any third-party software.

4. **Ease of modification**  
   - If you want to tweak or customize the migration process, you can directly edit the `.bat` scripts.  
   - With an `.exe`, modifying behavior safely is extremely difficult.

5. **Transparency builds trust**  
   - Using `.bat` makes it clear that this tool is designed for IT admins and power users who care about **seeing and controlling what happens** on their system.

**Bottom line:**  
`.bat` files may look “scary” at first glance, but they are actually the **safest, most auditable, and flexible** way to perform full Windows migration.

## Checksums

To check and verify the hash of each script, you can use CertUtil (built-in Windows tool)

Open Command Prompt.

Run: `certutil -hashfile "FILE_PATH" SHA256`

Verify against valid hashes:

| SHA256 Hash | File Path |
|------------|-----------|
| 2BC15002266D14CF0245208C50AD8AB7056A16DAE6FA0B730D50DAD0E331EC23 | Migrate\Export\CopyUserData.bat |
| A81DC9C1D47286375C8533826796F2BDC2D3F65C748B2BF7938DC23BCEB660EC | Migrate\Export\ExportWindowsSettings.bat |
| CAE18F5D5CA8EAA5F87BAC40DD28AB845E1604C3E8794128C6C0A46F88BCF582 | Migrate\Install\Checksums.bat |
| 0624695745E0DEFBA6B698939C3576F9BF453CC3E61CC63871CE892B8BF13A75 | Migrate\Install\ImportBrowserData.bat |
| 2D4B4B36FA2388A6D2D38E6C6BCA0A35743CAD3EEAB4190030CA2BD2C2536E19 | Migrate\Install\ImportHosts.bat |
| FAD663C1199EAC5BEA3CCF905BD02067CA30FDCFCDD255114EB69DC75EBA021E | Migrate\Install\ImportPath.bat |
| 76879A0432B8DBC2BEE6BBF72681FF17FF7637BD64B7986CBF7787CA62D03448 | Migrate\Install\ImportWifi.bat |
| 89A8ED2E250706C98EE80564DF1491ECF8D6E593CE53F294CE9F9AAE486145E3 | Migrate\Install\InstallFirewall.bat |
| CFCC033E2CDB3CD798EC8F63E1CA881DE32A2035658ED86759E073CFED148599 | Migrate\Install\InstallNextDNS.bat |
| F37BE85712CAA6598A51825F0149B14A7CF6F192EBEF603CDBF4E9C4226E9F5B | Migrate\Install\InstallSoftware.bat |
| F3EEF0D1F79777A38C4FF2795ED58262EA1B69AB542B6D0B93A297D0AA6B7830 | Migrate\Install\InstallSoftwareWOW64.bat |
| E7FD0DA8799683F50AD5C3C7DCAF228FF7B243F0F5D19F6EF57D23418D549836 | Migrate\Install\optional\NextDNSSoftware.bat |
| 1932B172973443B8C49CA9428CF48E7432D877EF644186FA03E6CE128DBF27B2 | Migrate\Install\optional\PortMasterAMDSoftware.bat |
| 84BA2659ECC4CE1247C04E3C6BF42FACCDC72F5CE7CF1F7DACE0AC8B4EDF834F | Migrate\Install\optional\PuttySoftware.bat |
| CDD1A55154DD7C0453E18BB12C80E7935ACA4A2CA5927C85B384FB51940AA166 | Migrate\Install\optional\StirlingPDFSoftware.bat |
| 5DFFF434F5ED000D226F138FAB65E958400BBB35C21F666A2214D973A5775EE6 | Migrate\Install\optional\Utilities.bat |
| B6412EF6A0A7A5A649427B3CE81FC7F4D6D7CB7CFD6DC1828FA08CF989A1BE52 | Migrate\Install\optional\WinSCPSoftware.bat |
| 64C3E88BC544CFDEBF44EC0C7E7D975BF8FF6C2EF6BFD9E2C4E023543DAECAAA | Migrate\Install\Uninstall\UninstallNextDNS.bat |
