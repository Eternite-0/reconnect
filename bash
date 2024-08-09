#reconnect to campus net

$userId = 'here is your user Id'
$password = 'here is your password'

Write-Host 'start check connection state'
$Response = Invoke-WebRequest -Uri http://123.123.123.123 -TimeoutSec 10 -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0"
$code = $?
if ($code -eq $false) {
	Write-Host "maybe connection no problem"
	exit 0
}
elseif ($content -eq $null) {
	Write-Host "wrong exitcode: ${code}"
	Write-Host "fetch querystring failed"
	Write-Host "content: ${Response.RawContent}"
	exit 1
}

Write-Host "content is ${content}"
$IsMatch = $Response.RawContent -match "(http://[^']*)"
if ($IsMatch -ne $true)
{
    Write-Host "Couldn't find dest url"
    exit 2
}
$QueryString = $Matches[0].Split('?')[1];
Write-Host "queryString is ${QueryString}"

$Form = @{
    "userId" = $userId
    "password" = $password
    "passwordEncrypt" = "False"
    "queryString" = $QueryString
}

$content = Invoke-WebRequest -Uri http://10.0.22.3/eportal/InterFace.do?method=login -Method Post -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0" -Body $Form
Write-Host "result: $?"
Write-Host $content
