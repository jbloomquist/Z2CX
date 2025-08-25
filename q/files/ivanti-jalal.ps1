Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force
taskkill /IM SoftMon.exe /F
Set-Service -Name Softmon -Status stopped -StartupType disabled
Remove-Item -Path "C:\Program Files (x86)\LANDesk\LDClient\SoftMon.exe" -Force
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri "https://ivanticloud.blob.core.windows.net/agrilife-ivanti/IvantiAgents/Workstation%20Agents/AgriLife/AgriLifeWorkstation24SU3.zip?sv=2023-11-03&spr=https&st=2025-08-14T15%3A37%3A35Z&se=2028-11-11T16%3A37%3A00Z&sr=b&sp=r&sig=ajm2i4CHRinWep83FCA1g06ky4xOePZxuMeh%2FNN%2B8F8%3D" -OutFile "C:\windows\temp\AgriLifeWorkstation24SU3.zip" -TimeoutSec 900
Expand-Archive -Path "C:\windows\temp\AgriLifeWorkstation24SU3.zip" -DestinationPath "C:\windows\temp\" -Force
C:\Windows\Temp\EPMAgentInstaller.exe /force
