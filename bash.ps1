#!/bin/bash
# 重新连接到校园网的脚本

# 用户应根据提示替换以下变量为实际的用户名和密码
userId='YOUR_USER_ID'   # 待填：这里替换为你的用户名
password='YOUR_PASSWORD' # 待填：这里替换为你的密码

echo '开始检查连接状态'
# 检查网络状态的服务器IP地址保持不变
checkIp='123.123.123.123' # 这个IP地址用于检查网络状态，保持不变
# 待填：以下IP地址应根据实际情况替换为登录校园网的服务器IP地址
loginIp='FILL_WITH_LOGIN_IP'   # 待填：这里替换为登录校园网的服务器IP地址或域名

# 使用curl检查网络连接状态
content=$(curl http://${checkIp} -s -m 10 \
              -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0")
code=$?

# 检查curl命令的退出状态码
if [ $code -eq 0 ]; then
    echo "网络连接正常"
    exit 0
elif [ $code -eq 28 ]; then
    echo "连接超时，但可能仍然连接正常"
    exit 0
else
    echo "错误退出码: ${code}"
    echo "获取网络状态失败"
    exit 1
fi

# 以下部分在网络状态检查失败时不会执行
echo "内容是 ${content}"
# 尝试从curl获取的内容中提取查询字符串
queryString=$(echo $content | grep -o "http[^']*" | awk -F "?" '{print $2}')
if [ -z "$queryString" ]; then
    echo "未能从响应中提取查询字符串"
    exit 1
fi
echo "查询字符串是 ${queryString}"

# 使用curl命令通过POST请求登录校园网络
content=$(curl http://${loginIp}/eportal/InterFace.do?method=login -vv -X POST \
              -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0" \
              -d "userId=${userId}&password=${password}&passwordEncrypt=false" \
              --data-urlencode "queryString=${queryString}")
echo "登录结果状态码: $?"
echo "登录内容: $content"
