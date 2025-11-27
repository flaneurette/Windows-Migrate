@echo off
setlocal enabledelayedexpansion

:: Set the target path for your software list text file
set TARGET=%USERPROFILE%\Desktop\Migrate\Data

:: Set the path to the text file containing the list of programs
set "software_list_file=%TARGET%\Lists\installed_programs_wow64.txt"

:: Check if the software list file exists
if not exist "%software_list_file%" (
    echo Software list file not found: %software_list_file%
    pause
    exit /b
)

:: Set the log file path for tracking installation actions
set "log_file=%TARGET%\Lists\install_log_wow64.txt"

:: Initialize the log file
echo Installation Log - %date% %time% > "%log_file%"

:: Loop through the software list
for /f "usebackq delims=" %%S in ("%software_list_file%") do (
    set "skip_current=0"  :: Reset skip flag to 0 at the start of each iteration
    echo Searching for: %%S
    echo Searching for: %%S >> "%log_file%"

    :: Step 1: Normalize the program name using PowerShell
    for /f "delims=" %%a in ('powershell -Command "$search_name = '%%S';" ^
        "$clean_name = [System.Text.RegularExpressions.Regex]::Replace($search_name, '\([^\)]*\)', '');" ^
        "$clean_name = [System.Text.RegularExpressions.Regex]::Replace($clean_name, '[0-9]', '');" ^
        "$clean_name = [System.Text.RegularExpressions.Regex]::Replace($clean_name, '[^a-zA-Z ]', '');" ^
        "$clean_name = [System.Text.RegularExpressions.Regex]::Replace($clean_name, '\s+', ' ').Trim();" ^
        "$clean_name"') do (
        set "search_name=%%a"
    )

    :: Check if search name is empty and skip if it is
    if "!search_name!"=="" (
        echo Empty search name after normalization. Skipping. >> "%log_file%"
        set "skip_current=1"  :: Set flag to skip this iteration
    )

    :: Step 2: Run the winget search with the cleaned name
    if !skip_current! equ 0 (
        echo Running winget search for "!search_name!"...
        winget search -q "!search_name!" > "%USERPROFILE%\Desktop\winget_search_output.txt"

        set counter=0
        for /f "tokens=1,2,3*" %%A in ('findstr /r /v "^$" "%USERPROFILE%\Desktop\winget_search_output.txt"') do (
            set /a counter+=1
            echo !counter!. %%A - %%B %%C
        )

        :: If no results are found, attempt searching with just the first word
        if "!counter!"=="0" (
            echo No matches found for "!search_name!". Attempting to search with the first word only.
            for /f "tokens=1" %%w in ("!search_name!") do set "first_word=%%w"
            echo Searching for first word: !first_word!
            winget search -q "!first_word!" > "%USERPROFILE%\Desktop\winget_search_output.txt"

            :: Reset the counter and try again with just the first word
            set counter=0
            for /f "tokens=1,2,3*" %%A in ('findstr /r /v "^$" "%USERPROFILE%\Desktop\winget_search_output.txt"') do (
                set /a counter+=1
                echo !counter!. %%A - %%B %%C
            )
        )

        :: If no results are still found after the second search, set the flag to skip this software
        if "!counter!"=="0" (
            echo No matches found for "!search_name!". Skipping.
            echo No matches found for "!search_name!". Skipping. >> "%log_file%"
            set "skip_current=1"  :: Set flag to skip this iteration
        )
    )

    :: Prompt user for installation choice only if no skip flag
    if !skip_current! equ 0 (
        :prompt_choice
        set /p user_choice="Which version of !search_name! do you want to install? Enter number or C to cancel: "

        :: Allow the user to cancel the installation
        if /i "!user_choice!"=="C" (
            echo Skipping installation for "!search_name!" as requested by user.
            echo Skipping installation for "!search_name!" as requested by user. >> "%log_file%"
            set "skip_current=1"  :: Set flag to skip this iteration
        )

        :: Validate user input and install the selected software
        if !user_choice! geq 1 if !user_choice! leq !counter! (
            set selection_id=
            set counter=0
            for /f "tokens=1,2,3*" %%A in ('findstr /r /v "^$" "%USERPROFILE%\Desktop\winget_search_output.txt"') do (
                set /a counter+=1
                if !counter! equ !user_choice! (
                    set selection_id=%%B
                )
            )

            if defined selection_id (
                echo Installing "!search_name!" with ID !selection_id!...
                echo Installing "!search_name!" with ID !selection_id!... >> "%log_file%"
                winget install !selection_id!
            ) else (
                echo Invalid selection. Skipping installation for "!search_name!".
                echo Invalid selection. Skipping installation for "!search_name!" >> "%log_file%"
                set "skip_current=1"  :: Set flag to skip this iteration
            )
        ) else (
            echo Invalid selection. Please enter a number between 1 and !counter! or C to cancel.
            goto :prompt_choice
        )
    )

    :: Skip this iteration if the flag is set
    if !skip_current! equ 1 (
        echo Skipping to next package...
        echo Skipping to next package... >> "%log_file%"
        echo.
        continue
    )

)

endlocal
pause
