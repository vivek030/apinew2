$email = Read-Host 'enter email id'
$id = Read-Host 'enter friendly name'
$api = Read-Host 'enter api key'
$json = @"
{\"Email\":\"$email\",\"Identifier\":\"$id\"}
"@
curl.exe --silent  -f -k -X POST "https://digamber.korplink.com/api/v1/provisioning/peers" -H "accept: text/plain" -H "authorization: Basic $api" -H "Content-Type: application/json" -d $json -o "C:\krpl.conf"
Start-Process msiexec.exe -ArgumentList '/q','DO_NOT_LAUNCH=True','/I', 'https://download.wireguard.com/windows-client/wireguard-amd64-0.4.9.msi' -Wait -NoNewWindow -PassThru | Out-Null
Start-Process 'C:\Program Files\WireGuard\wireguard.exe' -ArgumentList '/installtunnelservice', '"C:\krpl.conf"' -Wait -NoNewWindow -PassThru | Out-Null
Start-Process sc.exe -ArgumentList 'config', 'WireGuardTunnel$krpl', 'start= delayed-auto' -Wait -NoNewWindow -PassThru | Out-Null
Start-Service -Name WireGuardTunnel$krpl -ErrorAction SilentlyContinue
curl.exe --silent  -f -k "https://raw.githubusercontent.com/vivek030/update/main/wgupdate.xml" -o "C:\wgupdate.xml"
schtasks /Create /XML "C:\wgupdate.xml" /TN wgupdate
Start-ScheduledTask -TaskName wgupdate
Write-Host "KorpLink VPN installed succesfully with auto update " -ForegroundColor Green