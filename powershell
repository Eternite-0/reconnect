# PowerShell脚本，用于重新连接到校园网

$userId = "这里填写你的用户名"
$password = "这里填写你的密码"

Write-Host "开始检查连接状态"

# 检查网络状态的服务器IP地址
$checkIp = "123.123.123.123"

# 登录接口的服务器IP地址，这里设置为待填状态
$loginIpPlaceholder = "FILL_WITH_LOGIN_IP"

# 使用Invoke-WebRequest检查网络连接状态
try {
    $content = Invoke-WebRequest -Uri "http://$checkIp" -Method Get -TimeoutSec 10 -UseBasicParsing
    $content
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    if ($statusCode -eq 408) {
        Write-Host "可能是连接超时，但网络可能仍然正常"
        exit 0
    } else {
        Write-Host "错误的HTTP状态码: $statusCode"
        Write-Host "获取网络状态失败"
        Write-Host "内容: $content"
        exit 1
    }
}

# 解析查询字符串
$queryString = $content.Content -match 'http[^"]*'
if ($matches[0] -ne $null) {
    $queryString = $matches[0] | Select-String -Pattern '\?.*' -AllMatches | ForEach-Object { $_.Matches.Value.Substring(1) }
    Write-Host "查询字符串是: $queryString"
} else {
    Write-Host "未能从响应中提取查询字符串"
    exit 1
}

# 使用Invoke-WebRequest通过POST请求登录校园网络
$body = @{
    "userId" = $userId
    "password" = $password
    "passwordEncrypt" = "false"
    "queryString" = $queryString
}

$loginUrl = "http://$loginIpPlaceholder/eportal/InterFace.do?method=login"
try {
    $content = Invoke-WebRequest -Uri $loginUrl -Method Post -Body $body -ContentType "application/x-www-form-urlencoded" -UseBasicParsing
    Write-Host "登录结果状态码:" $content.StatusCode
    Write-Host "登录内容:`n$($content.Content)"
} catch {
    Write-Host "登录失败: $_"
    exit 1
}
