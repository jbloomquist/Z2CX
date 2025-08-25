@ECHO OFF &SETLOCAL ENABLEDELAYEDEXPANSION
CD /D "%userprofile%\Desktop"

FOR /f "usebackq delims=" %%A IN (`powershell -nologo -noprofile -command ^
  "$r = Invoke-WebRequest -Uri 'https://www.hp.com/us-en/solutions/client-management-solutions/download.html' -UseBasicParsing; ($r.Links | Where-Object { $_.href -match 'hpia.*\.exe$' -and $_.href -match 'hpia\/hp-[^/]*\.exe$' })[0].href"`) DO (SET "HPIA_URL=%%A")

IF DEFINED HPIA_URL (
    ECHO Found URL: !HPIA_URL!

    SET "HPIA_NAME="
    FOR %%A IN ("!HPIA_URL:/=" "!") DO SET "HPIA_NAME=%%~A"

    ECHO Saving as: !HPIA_NAME!

    curl -sL "!HPIA_URL!" -o "!HPIA_NAME!"
) ELSE (
    ECHO Failed to extract HPIA URL.
)

EXIT /B
