::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::  Script: bm.bat
:::: Version: 0.8
:::: Updated: 2024-08-28
::::  Source: z2.cx/bm
::::
:::: Add script location to user %path% environment variable to use it as intended. 
:::: Run "bm" to see usage info.
::::
:::: This script is incomplete and actively being updated. 
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@ECHO OFF &SETLOCAL disabledelayedexpansion
TITLE bm

:BM_PREINIT
IF NOT EXIST "%~dp0\bm" MKDIR "%~dp0\bm"
IF EXIST "%~dp0\bm\defaultbrowser" GOTO BM_INIT
IF EXIST "%~dp0\..\bm.bat" GOTO BM_CRITICAL_ERROR_INFREC
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
SET /P exitprompt=Press enter to exit and then run bm again with the desired arguments.
GOTO BM_QUIT

:BM_INIT
SET choice=""
IF "%~1" EQU "" (GOTO BM_USAGE) ELSE (IF "%~1" EQU "-?" GOTO BM_USAGE) & IF "%~1" EQU "/?" (GOTO BM_USAGE) ELSE (IF /I "%~1" EQU "help" GOTO BM_USAGE)
IF "%~1" EQU "BM" GOTO BM_SOURCE
IF "%~1" EQU "-D" DEL %~dp0\bm\defaultbrowser & DEL %~dp0\bm\dfbrowserflags && GOTO BM_PREINIT
IF "%~1" EQU "-I" GOTO BM_INSPECT
IF "%~1" EQU "-L" GOTO BM_READOUT
IF "%~1" EQU "-r" GOTO BM_REMOVE
IF "%~1" EQU "-R" GOTO BM_REMOVE_NOPROMPT
IF "%~1" EQU "-s" GOTO BM_SHOWFOLDER
IF EXIST "%~dp0\bm\defaultbrowser" SET /P browser=<%~dp0\bm\defaultbrowser
IF EXIST "%~dp0\bm\dfbrowserflags" SET /P flags=<%~dp0\bm\dfbrowserflags
IF EXIST "%~dp0\bm\%~1" SET /P address=<%~dp0\bm\%~1
ECHO %~1 | FINDSTR /C:"-" >nul && GOTO BM_ERROR_INVALID_OPTION_HYPHEN
IF NOT EXIST "%~dp0\bm\%~1" IF "%~2" NEQ "" IF "%~2" NEQ "bm" IF "%~2" NEQ "bm.bat" GOTO BM_MAKE_NOPROMPT
IF NOT EXIST "%~dp0\bm\%~1" IF "%~1" EQU "bm" GOTO BM_QUIT_ERROR1
IF NOT EXIST "%~dp0\bm\%~1" SET /P choice=%~1 doesn't exist. Create label called "%~1"? [Y/N]
IF /I "%choice%" EQU "Y" (GOTO BM_MAKE) ELSE (IF /I "%choice%" EQU "N" GOTO BM_QUIT)
FOR /F "delims=" %%u IN ('FINDSTR ://* %~dp0\bm\%~1') DO SET "url=%%u"
FOR /F "delims=" %%u IN ('FINDSTR /I ".bat .cmd call*" "%~dp0\bm\%~1"') DO SET "call=%%u"
IF EXIST "%~dp0\bm\%~1" IF DEFINED url START "" %browser% %flags% %address% && GOTO BM_QUIT
IF EXIST "%~dp0\bm\%~1" IF DEFINED call CALL %address% && GOTO BM_QUIT
IF EXIST "%~dp0\bm\%~1" IF NOT DEFINED url IF NOT DEFINED call START "" "%address%" && GOTO BM_QUIT
ECHO Invalid option.
PAUSE
GOTO BM_INIT

:BM_MAKE
ECHO What is the desired target for label: "%~1"?
SET /P bmaddress=Path: 
IF /I "%bmaddress%" EQU "%~dp0bm.bat" (GOTO BM_CRITICAL_ERROR_TARGETSELF) ELSE (IF /I "%bmaddress%" EQU "..\bm.bat" GOTO BM_CRITICAL_ERROR_TARGETSELF)
>"%~dp0\bm\%1" ECHO(%bmaddress%
:BM_MAKE_SR1
SET /P open=Open %~1 now? [Y/N]
IF /I "%open%" EQU "Y" ( GOTO BM_INIT ) ELSE (IF /I "%open%" EQU "N" GOTO BM_QUIT)
ECHO Invalid option.
GOTO BM_MAKE_SR1

:BM_MAKE_NOPROMPT
>"%~dp0\bm\%~1" ECHO(%~2
ECHO %~1 bookmark created, points to %~2.
GOTO BM_QUIT

:BM_INSPECT
IF EXIST "%~dp0\bm\%~2" SET /P bminspect=<%~dp0\bm\%~2
IF EXIST "%~dp0\bm\%~2" ECHO %bminspect% && GOTO BM_QUIT
IF NOT EXIST "%~dp0\bm\%~2" ECHO %~2 is not a valid Label. Run BM -L to view all labels. && GOTO BM_QUIT

:BM_READOUT
DIR /B %~dp0\bm\
GOTO BM_QUIT

:BM_REMOVE
IF EXIST "%~dp0\bm\%~2" SET /P delete=Remove "%~2"? [Y/N]
IF /I "%delete%" EQU "Y" DEL "%~dp0\bm\%~2" && GOTO BM_QUIT
IF /I "%delete%" EQU "N" GOTO BM_QUIT
ECHO Invalid option.
GOTO BM_QUIT

:BM_REMOVE_NOPROMPT
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
ECHO Or, run bm BM to view the script in Notepad and delete Line 82 of the script.
ECHO(
ECHO You Monster.
GOTO BM_QUIT

:BM_CRITICAL_ERROR_INFREC
ECHO Detected bm.bat one level up... Please remove bm.bat from %~dp0\.. before running bm.bat from %~dp0
ECHO This is to avoid unintentional infinite and recursive loops, or fork-bombing.
GOTO BM_QUIT

:BM_QUIT_ERROR1
ECHO Error: "bm" cannot be used as a bookmark label. Type "bm BM" to view script source in Notepad.
GOTO BM_QUIT

:BM_QUIT
EXIT /B
