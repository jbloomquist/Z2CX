@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

:: Get running OneDrive path
FOR /F "DELIMS=" %%I IN ('POWERSHELL -NoProfile -Command "(Get-Process OneDrive -ErrorAction SilentlyContinue | Select-Object -First 1).Path"') DO SET "ONEDRIVE_PATH=%%I"

:: If not running, try to start it
IF "!ONEDRIVE_PATH!"=="" (
    ECHO OneDrive is not currently running. 
    ECHO This script will attempt to start OneDrive
    PAUSE

    :: Try per-user AppData first
    IF EXIST "%LOCALAPPDATA%\Microsoft\OneDrive\OneDrive.exe" (
        START "" "%LOCALAPPDATA%\Microsoft\OneDrive\OneDrive.exe"
        SET "ONEDRIVE_PATH=%LOCALAPPDATA%\Microsoft\OneDrive\OneDrive.exe"
        ECHO Started OneDrive from %LOCALAPPDATA%\Microsoft\OneDrive\OneDrive.exe
        GOTO CONTINUE
    )

    :: Try Program Files x64
    IF EXIST "C:\Program Files\Microsoft OneDrive\OneDrive.exe" (
        START "" "C:\Program Files\Microsoft OneDrive\OneDrive.exe"
        SET "ONEDRIVE_PATH=C:\Program Files\Microsoft OneDrive\OneDrive.exe"
        ECHO Started OneDrive from C:\Program Files\Microsoft OneDrive\OneDrive.exe
        GOTO CONTINUE
    )

    :: If neither exists
    ECHO OneDrive executable not found on this system.
    PAUSE
    EXIT /B
)

:CONTINUE
ECHO OneDrive is running from: !ONEDRIVE_PATH!
ECHO.
ECHO Choose an action:
ECHO 1 - Shutdown OneDrive
ECHO 2 - Reset OneDrive
SET /P CHOICE=Enter 1 or 2: 

IF "!CHOICE!"=="1" (
    "!ONEDRIVE_PATH!" /shutdown
    ECHO OneDrive has been shut down.
) ELSE IF "!CHOICE!"=="2" (
    "!ONEDRIVE_PATH!" /reset
    ECHO OneDrive has been reset.
) ELSE (
    ECHO Invalid choice.
)
PAUSE
EXIT /B
