@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
TITLE rules

SET "rulesfile=%~dp0rules.txt"

:: ensure file exists but don't inject a blank line
IF NOT EXIST "%rulesfile%" ( TYPE NUL > "%rulesfile%" )


:: check args
IF "%~1"=="" GOTO :showall

SET "cmd=%~1"
SET "arg=%~2"

:: normalize switches
IF /I "%cmd%"=="new"    SET "cmd=new"
IF /I "%cmd%"=="+"      SET "cmd=new"
IF /I "%cmd%"=="/n"     SET "cmd=new"
IF /I "%cmd%"=="/new"   SET "cmd=new"

IF /I "%cmd%"=="del"    SET "cmd=del"
IF /I "%cmd%"=="-"      SET "cmd=del"
IF /I "%cmd%"=="/d"     SET "cmd=del"
IF /I "%cmd%"=="/del"   SET "cmd=del"
IF /I "%cmd%"=="remove" SET "cmd=del"
IF /I "%cmd%"=="/remove" SET "cmd=del"

IF /I "%cmd%"=="rule"   SET "cmd=rule"
IF /I "%cmd%"=="/r"     SET "cmd=rule"
IF /I "%cmd%"=="/rule"  SET "cmd=rule"

IF /I "%cmd%"=="help"   SET "cmd=help"
IF /I "%cmd%"=="/?"     SET "cmd=help"
IF /I "%cmd%"=="/h"     SET "cmd=help"
IF /I "%cmd%"=="/help"  SET "cmd=help"

:: dispatch
IF "%cmd%"=="new"  GOTO :add
IF "%cmd%"=="del"  GOTO :delete
IF "%cmd%"=="rule" GOTO :onerule
IF "%cmd%"=="help" GOTO :help

GOTO :showall

:add
IF "%~2"=="" (
    ECHO no rule text provided
    EXIT /B 1
)
>>"%rulesfile%" ECHO %~2
ECHO rule added: %~2
EXIT /B 0

:delete
FOR /F "usebackq delims=" %%A IN ("%rulesfile%") DO (
    SET /A count+=1
)
IF "%arg%"=="" (
    ECHO no rule number provided
    EXIT /B 1
)
IF %arg% GTR !count! (
    ECHO rule %arg% not found
    EXIT /B 1
)
IF %arg% LEQ 0 (
    ECHO invalid rule number
    EXIT /B 1
)

SET "tmpfile=%rulesfile%.tmp"
SET /A line=0
> "%tmpfile%" (
    FOR /F "usebackq delims=" %%A IN ("%rulesfile%") DO (
        SET /A line+=1
        IF NOT !line! EQU %arg% ECHO %%A
    )
)
MOVE /Y "%tmpfile%" "%rulesfile%" >NUL
ECHO deleted rule %arg%
EXIT /B 0

:onerule
IF "%arg%"=="" (
    ECHO no rule number provided
    EXIT /B 1
)
SET /A line=0
SET "found="
FOR /F "usebackq delims=" %%A IN ("%rulesfile%") DO (
    SET /A line+=1
    IF !line! EQU %arg% (
        ECHO !line!. %%A
        SET "found=1"
    )
)
IF NOT DEFINED found ECHO rule %arg% not found
EXIT /B 0

:showall
SET /A line=0
FOR /F "usebackq delims=" %%A IN ("%rulesfile%") DO (
    SET /A line+=1
    ECHO !line!. %%A
)
EXIT /B 0

:help
ECHO Usage: rules [command] [argument]
ECHO.
ECHO Commands:
ECHO   new  "text"   - add a new rule
ECHO   del  N        - delete rule number N
ECHO   rule N        - show only rule number N
ECHO   help          - show this help summary
ECHO.
ECHO Run without arguments to list all rules.
EXIT /B 0
