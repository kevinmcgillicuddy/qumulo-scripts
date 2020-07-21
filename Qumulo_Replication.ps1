
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


$runningLong=$false
$replicationdetail=Invoke-RestMethod -Uri "https://$url_base:8000/v1/replication/source-relationships/status/" -method GET -Headers $header | convertto-json
$hashtable = @{}
(ConvertFrom-Json $replicationdetail).psobject.properties  |  Foreach { $hashtable[$_.Name] = $_.Value }

foreach ($rep in $hashtable.Value.job_start_tim){
$startdate = [datetime]::parse($hashtable.Value.job_start_time)
$currentdate = date
$totalruntime = $currentdate - $startdate
#if ($totalruntime.TotalMinutes > 240){$runningLong=$true}
}



write-host "<prtg>"
write-host "<result>"
write-host "<channel>Replication Time Minutes</channel>"
write-host "<value>"$totalruntime.minutes"</value>"
write-host "<LimitMode>1</LimitMode>"
write-host "<limitmaxerror>200</limitmaxerror>"
write-host "</result>"
write-host "</prtg>"
