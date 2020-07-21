
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
[System.Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$username = "admin"
$password = Get-Content "C:\Temp\QPassword.txt" | ConvertTo-SecureString
$url_base = 'ENTER_HERE FQDN'
$bodydata = @{
    username = $username
	password = $password
}

$body = $bodydata | convertto-json

$token = Invoke-RestMethod -Uri "https://$url_base:8000/v1/session/login" -Method Post -Body $body -ContentType 'application/json'
$token = $token.bearer_token | Out-String

$header = @{
    Authorization = "Bearer $token"
}


$alert=0
$replicationdetail=Invoke-RestMethod -Uri "https://$url_base:8000/v1/replication/source-relationships/status/" -method GET -Headers $header | convertto-json
$hashtable = @{}
(ConvertFrom-Json $replicationdetail).psobject.properties  |  Foreach { $hashtable[$_.Name] = $_.Value }
foreach ($id in $hashtable.value.error_from_last_job){
if ($id) {$alert=2} else {"empty"}
}


write-host "<prtg>"
write-host "<result>"
write-host "<channel>Replication Errors</channel>"
write-host "<value>$alert</value>"
write-host "<LimitMode>1</LimitMode>"
write-host "<limitmaxerror>1</limitmaxerror>"
write-host "</result>"
write-host "</prtg>"


