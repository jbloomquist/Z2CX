@ECHO OFF &SETLOCAL ENABLEDELAYEDEXPANSION
TITLE cxurl

:: DEFINE RESPONSE FILES
SET "RESPFILE=%TEMP%\cx-response.html"
SET "LINKSFILE=%TEMP%\cx-links.txt"
SET "PAGEPREFIX=%TEMP%\cx-page"

:: START CLEAN
IF EXIST "%RESPFILE%" DEL /Q "%RESPFILE%"
IF EXIST "%LINKSFILE%" DEL /Q "%LINKSFILE%"
DEL /Q "%PAGEPREFIX%-*.html" 2>NUL

:: CHECK ARG
IF "%~1"=="" (
    ECHO No URL was passed. Please run again with a valid URL target.
    EXIT /B 1
)

:: FETCH
IF "%~2"=="" (
    CURL -s -L "%~1" > "%RESPFILE%"
) ELSE (
    CURL -s -L -u "%~2" "%~1" > "%RESPFILE%"
)

:: PARSE + SPLIT INTO PAGES
POWERSHELL -NoLogo -NoProfile -Command "$respfile=Join-Path $env:TEMP 'cx-response.html';$html=(Get-Content $respfile -Raw 2>$null);if(-not $html){$html=''};$base='%~1';if(-not $base.EndsWith('/')){$base+='/'};$pat='<a\b[^>]*href\s*=\s*[\x22''](?<url>[^\x22'']+)[\x22''][^>]*>(?<text>.*?)</a>';$opts=[System.Text.RegularExpressions.RegexOptions]::IgnoreCase -bor [System.Text.RegularExpressions.RegexOptions]::Singleline;$ms=[regex]::Matches($html,$pat,$opts);$items=@();foreach($m in $ms){$u=$m.Groups['url'].Value;if($u -notmatch '^[a-z][a-z0-9+.\-]*://'){$u=[Uri]::new([Uri]$base,$u).AbsoluteUri};$t=$m.Groups['text'].Value;$t=[regex]::Replace($t,'<[^>]+>',' ');$t=($t -replace '\s+',' ').Trim();if([string]::IsNullOrWhiteSpace($t)){$t=$u};$items+=[pscustomobject]@{Text=$t;Url=$u}};if($items.Count -eq 0){$ms2=[regex]::Matches($html,'https?://[^\x22''\s<>]+');foreach($m in $ms2){$u=$m.Value;$items+=[pscustomobject]@{Text=$u;Url=$u}}};if($items.Count -eq 0){exit};$pageSize=23;for($i=0;$i -lt $items.Count;$i+=$pageSize){$end=$i+$pageSize-1;if($end -ge $items.Count){$end=$items.Count-1};$chunk=$items[$i..$end];$out=($chunk|ConvertTo-Json -Compress);$p=[int]($i/$pageSize+1);$out|Out-File ('%PAGEPREFIX%-'+$p+'.html') -Encoding UTF8}"

:: TUI LOOP INSIDE POWERSHELL

POWERSHELL -NoLogo -NoProfile -Command "$max=(Get-ChildItem '%PAGEPREFIX%-*.html').Count;$page=1;$i=0;[System.Console]::TreatControlCAsInput=$true;$esc=[char]27;$mint=$esc+'[38;5;121m';$reset=$esc+'[0m';while($true){$items=Get-Content ('%PAGEPREFIX%-'+$page+'.html') | ConvertFrom-Json;Clear-Host;for($j=0;$j -lt $items.Count;$j++){if($j -eq $i){Write-Host ($mint+'> '+$items[$j].Text+$reset)}else{Write-Host ('  '+$items[$j].Text)}};Write-Host '';Write-Host ('-- Page '+$page+' of '+$max+' --');Write-Host '';Write-Host '[Up/Down = move]  [Enter = open/download]  [Right = next page]  [Left = prev page]';$key=$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');if($key.VirtualKeyCode -eq 38 -and $i -gt 0){$i--};if($key.VirtualKeyCode -eq 40 -and $i -lt $items.Count-1){$i++};if($key.VirtualKeyCode -eq 39){$page++;if($page -gt $max){$page=1};$i=0};if($key.VirtualKeyCode -eq 37){$page-- ;if($page -lt 1){$page=$max};$i=0};if($key.VirtualKeyCode -eq 13){$u=$items[$i].Url;if($u -match '\.(png|jpe?g|gif|bmp|webp|svg|mp3|wav|ogg|flac|mp4|mkv|webm|avi|mov|txt|log|rtf|bat|cmd|sh|bash|ps1|zip|7z|rar|tar|gz|bz2|tgz|xz)$'){$fn=[System.IO.Path]::GetFileName($u);$dl=Join-Path $env:USERPROFILE 'Downloads';if(-not(Test-Path $dl)){New-Item -ItemType Directory -Path $dl|Out-Null};& curl.exe -s $u -o (Join-Path $dl $fn);Write-Host ('Downloaded: '+(Join-Path $dl $fn));exit}else{$auth='%~2';if([string]::IsNullOrWhiteSpace($auth)){& '%~f0' $u}else{& '%~f0' $u $auth};exit}}}"

:: CLEANUP
DEL /Q "%PAGEPREFIX%-*.html" 2>NUL
::IF EXIST "%RESPFILE%" DEL /Q "%RESPFILE%"

ENDLOCAL
