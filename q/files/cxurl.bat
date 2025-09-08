@ECHO OFF &SETLOCAL ENABLEDELAYEDEXPANSION
TITLE cxurl

:: DEFINE RESPONSE FILES
SET "RESPFILE=%TEMP%\cx-response.html"
SET "LINKSFILE=%TEMP%\cx-links.txt"

:: START CLEAN
IF EXIST "%RESPFILE%" DEL /Q "%RESPFILE%"
IF EXIST "%LINKSFILE%" DEL /Q "%LINKSFILE%"

:: CHECK ARG
IF "%~1"=="" (
    ECHO No URL was passed. Please run again with a valid URL target.
    EXIT /B 1
)

:: FETCH
CURL -s "%~1" > "%RESPFILE%"

:: PARSE + TUI
POWERSHELL -NoLogo -NoProfile -Command "$respfile=Join-Path $env:TEMP 'cx-response.html';$html=Get-Content $respfile -Raw;$pat='<a\b[^>]*href\s*=\s*[\x22''](?<url>https?://[^\x22'']+)[\x22''][^>]*>(?<text>.*?)</a>';$opts=[System.Text.RegularExpressions.RegexOptions]::IgnoreCase -bor [System.Text.RegularExpressions.RegexOptions]::Singleline;$ms=[regex]::Matches($html,$pat,$opts);$items=@();foreach($m in $ms){$u=$m.Groups['url'].Value;$t=$m.Groups['text'].Value;$t=[regex]::Replace($t,'<[^>]+>',' ');$t=($t -replace '\s+',' ').Trim();if([string]::IsNullOrWhiteSpace($t)){$t=$u};$items+=[pscustomobject]@{Text=$t;Url=$u}};if($items.Count -eq 0){$ms2=[regex]::Matches($html,'https?://[^\x22''\s<>]+');foreach($m in $ms2){$u=$m.Value;$items+=[pscustomobject]@{Text=$u;Url=$u}}};if($items.Count -eq 0){Write-Host 'No links found.';exit};$i=0;[System.Console]::TreatControlCAsInput=$true;$esc=[char]27;$mint=$esc+'[38;5;121m';$reset=$esc+'[0m';while($true){Clear-Host;for($j=0;$j -lt $items.Count;$j++){if($j -eq $i){Write-Host ($mint+'> '+$items[$j].Text+$reset)}else{Write-Host ('  '+$items[$j].Text)}};$key=$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');if($key.VirtualKeyCode -eq 38 -and $i -gt 0){$i--};if($key.VirtualKeyCode -eq 40 -and $i -lt $items.Count-1){$i++};if($key.VirtualKeyCode -eq 13){Start-Process $items[$i].Url;break}}"

:: CLEANUP
::IF EXIST "%RESPFILE%" DEL /Q "%RESPFILE%"

ENDLOCAL
