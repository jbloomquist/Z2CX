::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::  Script: bm.bat
:::: Version: 0.14-experimental
:::: Updated: 2025-08-26
::::  Source: z2.cx/bm.bat
::::
:::: Add script location to user %path% environment variable to use it as intended. 
:::: Run "bm" to see usage info.
::::
:::: This script is incomplete and actively being updated. 
:::: EXPERIMENTAL BUILD - NEW FEATURES / POTENTIALLY UNSTABLE / USE AT YOUR OWN RISK
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@ECHO OFF &SETLOCAL DISABLEDELAYEDEXPANSION
TITLE bm

:BM_FIRST_TIME_RUNNING
SET "rundir=%~dp0"
IF "%rundir:~-1%"=="\" SET "rundir=%rundir:~0,-1%"

FOR /F "skip=2 tokens=2,*" %%A IN ('REG QUERY "HKCU\Environment" /v PATH 2^>nul') DO SET "UserPath=%%B"

SETLOCAL ENABLEDELAYEDEXPANSION
ECHO !UserPath! | FINDSTR /I /C:"%rundir%" >NUL
ENDLOCAL

IF ERRORLEVEL 1 (
  ECHO %rundir% NOT found in user PATH.
  ECHO(
  ECHO This script will "install" to the directory that you are running it from.
  ECHO It will add the directory that it is run from to the USER PATH environment.
  ECHO Additionally, it will create a sub-directory in that directory called "bm".
  ECHO That directory will be where bookmarks you create with the script are stored.
  ECHO(
  ECHO If you continue, the script will do those things now.
  ECHO Exit and move this script, then re-run it if you wish to change the install location.
  ECHO(
  PAUSE
  POWERSHELL -NoProfile -Command "[Environment]::SetEnvironmentVariable('PATH', ($env:Path + ';%rundir%'), 'User')"
  ECHO(
  ECHO User Path Updated. To avoid any runtime expansion errors, this script will now open in a new CMD.
  PAUSE
  START "" /D "%rundir%" CMD /K "%~nx0"
  EXIT
) ELSE (
  GOTO BM_PREINIT
)

:BM_PREINIT
IF NOT EXIST "%~dp0\bm" MKDIR "%~dp0\bm"
IF NOT EXIST "%~dp0\bm\key" POWERSHELL -NoProfile -Command "[Text.Encoding]::UTF8.GetBytes((65..90 + 97..122 | Get-Random -Count 16 | %%{[char]$_}) -join '')" ^| Set-Content -Encoding Byte '%~dp0\bm\key'
IF EXIST "%~dp0\..\bm.bat" GOTO BM_CRITICAL_ERROR_INFREC
IF EXIST "%~dp0\bm\defaultbrowser" GOTO BM_INIT
SET browserchoice=""
CLS
ECHO(
ECHO  bm.bat
ECHO(
ECHO Default browser not set or -D flag was passed. Searching for browsers...
ECHO Please follow the prompts and then run bm again with the desired parameters.
ECHO(
IF EXIST "C:\Program Files\Google\Chrome\Application\chrome.exe" SET /P browserchoice="Google Chrome (64bit) detected, use as default browser? [Y/N]"
IF /I "%browserchoice%" EQU "Y" >"%~dp0\bm\defaultbrowser" ECHO(chrome && IF NOT EXIST "%~dp0\bm\dfbrowserflags" GOTO BM_PREINIT2
IF /I "%browserchoice%" EQU "N" SET browserchoice=""
IF EXIST "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" SET /P browserchoice=Google Chrome (32bit) detected, use as default browser? [Y/N]
IF /I "%browserchoice%" EQU "Y" >"%~dp0\bm\defaultbrowser" ECHO(chrome && IF NOT EXIST "%~dp0\bm\dfbrowserflags" GOTO BM_PREINIT2
IF /I "%browserchoice%" EQU "N" SET browserchoice=""
IF EXIST "C:\Program Files\Mozilla Firefox\firefox.exe" SET /P browserchoice=Mozilla Firefox (64bit) detected, use as default browser? [Y/N]
IF /I "%browserchoice%" EQU "Y" >"%~dp0\bm\defaultbrowser" ECHO(firefox && IF NOT EXIST "%~dp0\bm\dfbrowserflags" GOTO BM_PREINIT2
IF /I "%browserchoice%" EQU "N" SET browserchoice=""
IF EXIST "C:\Program Files (x86)\Mozilla Firefox\firefox.exe" SET /P browserchoice=Mozilla Firefox (32bit) detected, use as default browser? [Y/N]
IF /I "%browserchoice%" EQU "Y" >"%~dp0\bm\defaultbrowser" ECHO(firefox && IF NOT EXIST "%~dp0\bm\dfbrowserflags" GOTO BM_PREINIT2
IF /I "%browserchoice%" EQU "N" SET browserchoice=""
IF EXIST "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" SET /P browserchoice=Microsoft Edge detected, use as default browser? [Y/N]
IF /I "%browserchoice%" EQU "Y" >"%~dp0\bm\defaultbrowser" ECHO "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" && IF NOT EXIST "%~dp0\bm\dfbrowserflags" GOTO BM_PREINIT2
IF /I "%browserchoice%" EQU "N" SET browserchoice=""
ECHO No browsers were selected, or bm.bat was unable to locate any installed browsers. 
ECHO Please type the full path to the browser that you wish to use for bm.bat.
ECHO If your path has any spaces in it, please wrap the full path to the executable in quotation marks.
SET /P browserchoice=
>"%~dp0\bm\defaultbrowser" ECHO(%browserchoice% && GOTO BM_PREINIT2
ECHO Unexpected error occurred when setting defaultbrowser.
ECHO Please verify that you have write permissions for the folder that this script is being run from.
ECHO This script will now exit. & GOTO BM_QUIT
    
:BM_PREINIT2
CLS
ECHO Your default browser is now set. 
ECHO Please type any additional flags you wish to pass with the browser.
ECHO Examples: -incognito ^(chrome^), -private ^(firefox^), -inprivate ^(msedge^). 
ECHO If you don't wish to use any additional flags, just press enter.
SET /P flags=
>"%~dp0\bm\dfbrowserflags" ECHO(%flags%
CLS
ECHO Browser and Flags set.
ECHO You can run this setup again by passing the -D flag with bm.bat.
ECHO BM is now configured to open URL bm shortcuts. 
ECHO(
ECHO If you run bm without any additional parameters, it'll show you the usage information.
SET /P exitprompt=Press enter to exit and then run bm again with the desired arguments.
GOTO BM_QUIT

:BM_INIT
SET choice=""
IF "%~1" EQU "" (GOTO BM_USAGE) ELSE (IF "%~1" EQU "-?" GOTO BM_USAGE) & IF "%~1" EQU "/?" (GOTO BM_USAGE) ELSE (IF /I "%~1" EQU "help" GOTO BM_USAGE)
IF "%~1" EQU "BM" GOTO BM_SOURCE
IF "%~1" EQU "-SHA256" GOTO BM_CHECKSUM
IF "%~1" EQU "-D" DEL %~dp0\bm\defaultbrowser & DEL %~dp0\bm\dfbrowserflags && GOTO BM_PREINIT
IF "%~1" EQU "-I" GOTO BM_INSPECT
IF "%~1" EQU "-L" GOTO BM_READOUT
IF "%~1" EQU "-r" GOTO BM_REMOVE
IF "%~1" EQU "-R" GOTO BM_REMOVE_NOPROMPT
IF "%~1" EQU "-s" GOTO BM_SHOWFOLDER
IF "%~1" EQU "key" ECHO Keep it secret, keep it safe. & GOTO BM_QUIT
FOR /F "usebackq delims=" %%A IN (`POWERSHELL -NoProfile -Command "$enc=Get-Content -Raw '%~dp0\bm\%~1'; $key=Get-Content -Raw '%~dp0\bm\key'; $i=0; $bytes=[Convert]::FromBase64String($enc); $out = $bytes | %%{ [char]($_ -bxor [byte][char]$key[$i++%%$key.Length]) }; $out -join ''"`) DO (SET "address=%%A")
ECHO %~1 | FINDSTR /C:"-" >nul && GOTO BM_ERROR_INVALID_OPTION_HYPHEN
IF NOT EXIST "%~dp0\bm\%~1" IF "%~2" NEQ "" IF "%~2" NEQ "bm" IF "%~2" NEQ "bm.bat" GOTO BM_MAKE_NOPROMPT
IF NOT EXIST "%~dp0\bm\%~1" IF /I "%~1" EQU "bm" GOTO BM_QUIT_ERROR1
IF NOT EXIST "%~dp0\bm\%~1" SET /P choice=%~1 doesn't exist. Create label called "%~1"? [Y/N]
IF /I "%choice%" EQU "Y" (GOTO BM_MAKE) ELSE (IF /I "%choice%" EQU "N" GOTO BM_QUIT)
IF /I "%address:~0,7%" EQU "http://"  SET "url=1"
IF /I "%address:~0,8%" EQU "https://" SET "url=1"
IF /I "%address:~0,5%" EQU "call "  ( SET "call=1" &SET "address=%address:~5%" )
IF /I "%address:~-4%"  EQU ".bat" IF NOT DEFINED url SET "call=1"
IF /I "%address:~-4%"  EQU ".cmd" SET "call=1"
IF DEFINED url IF "%~2" NEQ "" (
  IF EXIST "%TEMP%\bm_url_append.txt" DEL "%TEMP%\bm_url_append.txt"
  > "%TEMP%\bm_url_append.txt" echo(%address%%~2

  POWERSHELL -NoProfile -Command "(Get-Content '%TEMP%\bm_url_append.txt') -replace ' ', '%%20' | Set-Content '%TEMP%\bm_url_append.txt'"

  FOR /F "usebackq delims=" %%A IN ("%TEMP%\bm_url_append.txt") DO SET "address=%%A"
)
IF DEFINED url IF EXIST "%TEMP%\bm_url_append.txt" SET /P address=<"%TEMP%\bm_url_append.txt"
IF EXIST "%~dp0\bm\defaultbrowser" SET /P browser=<%~dp0\bm\defaultbrowser
IF EXIST "%~dp0\bm\dfbrowserflags" SET /P flags=<%~dp0\bm\dfbrowserflags
IF EXIST "%~dp0\bm\%~1" IF DEFINED url START "" %browser% %flags% %address% && GOTO BM_QUIT
IF EXIST "%~dp0\bm\%~1" IF DEFINED call CALL %address%
IF DEFINED call GOTO BM_QUIT
IF EXIST "%~dp0\bm\%~1" IF NOT DEFINED url IF NOT DEFINED call CALL START "" "%address%" && GOTO BM_QUIT
ECHO Invalid option.
PAUSE
GOTO BM_INIT

:BM_CHECKSUM
CD %~dp0 & CertUtil -hashfile bm.bat SHA256 & CertUtil -hashfile bm.bat SHA256 > bm.bat.sha256 
ECHO Created bm.bat.sha256 in directory %~dp0 & GOTO BM_QUIT

:BM_MAKE
ECHO What is the desired target for label: "%~1"?
SET /P bmaddress=Path: 
IF /I "%bmaddress%" EQU "%~dp0bm.bat" (GOTO BM_CRITICAL_ERROR_TARGETSELF) ELSE (IF /I "%bmaddress%" EQU "..\bm.bat" GOTO BM_CRITICAL_ERROR_TARGETSELF)
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F "usebackq delims=" %%A IN (`POWERSHELL -NoProfile -Command "$plain='%bmaddress%';$key=Get-Content -Raw '%~dp0bm\key';$i=0;$enc=[Convert]::ToBase64String(([Text.Encoding]::UTF8.GetBytes($plain) | %%{ $_ -bxor [byte][char]$key[$i++%%$key.Length] }));$enc"`) DO (SET "bmencoded=%%A")
ENDLOCAL &SET "bmencoded=%bmencoded%"
>"%~dp0\bm\%1" ECHO(%bmencoded%
:BM_MAKE_SR1
SET /P open=Open %~1 now? [Y/N]
IF /I "%open%" EQU "Y" (GOTO BM_INIT) ELSE (IF /I "%open%" EQU "N" GOTO BM_QUIT)
ECHO Invalid option.
GOTO BM_MAKE_SR1

:BM_MAKE_NOPROMPT
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F "usebackq delims=" %%A IN (`POWERSHELL -NoProfile -Command "$plain='%~2';$key=Get-Content -Raw '%~dp0bm\key';$i=0;$enc=[Convert]::ToBase64String(([Text.Encoding]::UTF8.GetBytes($plain) | %%{ $_ -bxor [byte][char]$key[$i++%%$key.Length] }));$enc"`) DO (
    SET "bmencoded=%%A"
)
ENDLOCAL &SET "bmencoded=%bmencoded%"
>"%~dp0\bm\%~1" ECHO(%bmencoded%
ECHO %~1 bookmark created, points to %~2.
GOTO BM_QUIT

:BM_INSPECT
IF "%~2" EQU "key" ECHO Keep it secret. Keep it safe. && ECHO You'll need to look at this one manually. && GOTO BM_QUIT
IF EXIST "%~dp0\bm\%~2" (
  FOR /F "usebackq delims=" %%A IN (`POWERSHELL -NoProfile -Command "$enc=Get-Content -Raw '%~dp0\bm\%~2'; $key=Get-Content -Raw '%~dp0\bm\key'; $i=0; $bytes=[Convert]::FromBase64String($enc); $out = $bytes | ForEach-Object { [char]($_ -bxor [byte][char]$key[$i++ %% $key.Length]) }; $out -join ''"`) DO (
    ECHO %%A
  )
  GOTO BM_QUIT
)
ECHO %~2 is not a valid Label. Run BM -L to view all labels.
GOTO BM_QUIT


:BM_READOUT
DIR /B %~dp0\bm\
GOTO BM_QUIT

:BM_REMOVE
IF "%~2" EQU "key" ECHO You're about to delete your key file, are you sure you want to do this? && ECHO You will not be able to use any of your existing bookmarks anymore. && ECHO Please backup your key file from the bm folder before you do this. && ECHO If you do this, a new key will be created the next time you run the script. && PAUSE
IF EXIST "%~dp0\bm\%~2" SET /P delete=Remove "%~2"? [Y/N]
IF /I "%delete%" EQU "Y" DEL "%~dp0\bm\%~2" && GOTO BM_QUIT
IF /I "%delete%" EQU "N" GOTO BM_QUIT
ECHO Invalid option.
GOTO BM_QUIT

:BM_REMOVE_NOPROMPT
IF /I "%~2"=="key" (
  ECHO If you delete your key file, all of your bookmarks will be irretrievably inaccessible.
  ECHO Deleting your key cannot be done through the no prompt option.
  ECHO Should you still desire to delete your key, use the with prompt flag [-r].
  GOTO BM_QUIT
)
IF EXIST "%~dp0\bm\%~2" DEL "%~dp0\bm\%~2" && GOTO BM_QUIT
ECHO %~2 cannot be deleted because it does not exist.
ECHO Are you sure you didn't delete it already?
GOTO BM_QUIT

:BM_SHOWFOLDER
CD %~dp0bm && START "" . && GOTO BM_QUIT

:BM_SOURCE
NOTEPAD %~dp0bm.bat & GOTO BM_QUIT

:BM_USAGE
CLS
ECHO Bookmark management tool for Windows command-line environment.
ECHO(
ECHO  Usage: BM [-I][-r][-R] LABEL ^<optional:^>[TARGET]
ECHO(
ECHO  Label Examples: GGL, SYS32, wan, MyScript
ECHO(
ECHO  Target Examples:
ECHO    URL  https://google.com/        DIR  C:\Windows\System32\
ECHO    EXE  call curl icanhazip.com    BAT  D:\Script\myscript.bat
ECHO(
ECHO  Bookmarks label names are not case sensitive. [GGL] (This is a property of the Windows command-line)
ECHO(
ECHO  Additional parameters ARE case sensitive. (-r vs -R)
ECHO(
ECHO  bm -D    Rerun the default browser setup.
ECHO           This setup is run automatically the first time that you open bm.bat.
ECHO(
ECHO  bm -I    Inspect a bookmark. Prints the bookmark label's contents to the command-line.
ECHO  bm -L    List all existing bookmark labels.
ECHO(
ECHO  bm -r    Remove bookmark with yes/no prompt.
ECHO  bm -R    Remove bookmark without any prompt.
ECHO(
ECHO  bm -s    Open the bookmark labels folder in file explorer.
ECHO  bm BM    Open the bm.bat file in notepad. ( flag must be UPPERCASE)
ECHO(
GOTO BM_QUIT

:BM_ERROR_INVALID_OPTION_HYPHEN
ECHO First argument: %~1 contains an invalid character (-). This character is reserved for optional parameters.
ECHO(
ECHO Please use only alphanumeric characters. Bookmark label names are NOT case sensitive.
ECHO Type bm with no additional arguments in the command prompt to see more detailed information.
GOTO BM_QUIT

:BM_CRITICAL_ERROR_TARGETSELF
ECHO(
ECHO ERROR: Target cannot be self-referential. I mean, I guess IT COULD be, but it SHOULDN'T be. 
ECHO If you REALLY want to do this, create a shortcut to the batch file and target the .lnk file.
ECHO Or, run bm BM to view the script in Notepad and comment out Line 138 of the script.
ECHO(
ECHO You Monster.
GOTO BM_QUIT

:BM_CRITICAL_ERROR_INFREC
CLS
SET "parent="
PUSHD "%~dp0.."
SET "parent=%CD%"
POPD
ECHO WARNING: Detected bm.bat one level up... 
ECHO Please remove bm.bat from %parent% before running bm.bat from %~dp0
ECHO This is to avoid unintentional infinite and recursive loops, or fork-bombing.
ECHO(
ECHO If for whatever reason you want to disable this built-in protection;
ECHO Comment out line 51 from the bm.bat you're attempting to run by appending two colons ::
GOTO BM_QUIT

:BM_QUIT_ERROR1
ECHO Error: "bm" cannot be used as a bookmark label. Type "bm BM" to view script source in Notepad.
GOTO BM_QUIT

:BM_QUIT
ENDLOCAL
EXIT /B
