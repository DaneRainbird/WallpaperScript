@echo off

@REM Script to chnage wallpaper to the file specified in the .env file
@REM Author: Dane Rainbird (hello@danerainbird.me)
@REM Last Edited: 2023-05-13

@REM Get the argument passed to the script
SET ARGUMENT=%1

@REM Ensure that the argument is not empty, and that it is either "safe" or "unsafe"
IF "%ARGUMENT%"=="" (
    @REM If the argument is empty, exit with an error
    echo Argument not found. Exiting...
    exit /b 1
) ELSE IF NOT "%ARGUMENT%"=="safe" IF NOT "%ARGUMENT%"=="unsafe" (
    @REM If the argument is not "safe" or "unsafe", exit with an error
    echo Invalid argument. Only use 'safe' or 'unsafe'. Exiting...
    exit /b 1
)

@REM Get the safe and unsafe wallpepr file locations from from the .env file
for /F "usebackq tokens=1,2 delims==" %%G in (".env") do (
    if not "%%G"=="" (
        set "%%G=%%H"
    )
)

@REM Check if the wallpapers exist 
IF NOT EXIST %SAFE_WALLPAPER% (
    echo Safe wallpaper not found. Exiting...
    exit /b 1
)

IF NOT EXIST %UNSAFE_WALLPAPER% (
    echo Unsafe wallpaper not found. Exiting...
    exit /b 1
)

@REM Set wallpaper based on the ARGUMENT variable
IF "%ARGUMENT%"=="safe" (
    reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d %SAFE_WALLPAPER% /f
    reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v WallpaperStyle /t REG_SZ /d 2 /f
) ELSE IF "%ARGUMENT%"=="unsafe" (
    reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d %UNSAFE_WALLPAPER% /f
    reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v WallpaperStyle /t REG_SZ /d 0 /f
    reg add "HKEY_CURRENT_USER\Control Panel\Colors" /v Background /t REG_SZ /d 255,231,237 /f
)

@REM Turn off Active Desktop (if it's turned on) to ensure that the wallpaper is updated
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoActiveDesktop" /t REG_DWORD /d 00000001 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoActiveDesktopChanges" /t REG_DWORD /d 00000001 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ForceActiveDesktopOn" /t REG_DWORD /d 00000000 /f

@REM Use the UpdatePerUserSystemParameters command to update the wallpaper.
@REM This command is run 50 times to ensure that the wallpaper is updated as running it once doesn't always work.
@REM Why is Windows like this?
for /L %%i in (1,1,50) do (
    echo Reload %%i of 50
    start RUNDLL32.EXE user32.dll, UpdatePerUserSystemParameters
    timeout /t 1 /nobreak > NUL
)

@REM Exit with no error
exit /b 0