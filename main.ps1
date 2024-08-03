# 运行 `Install-Module MineStat` 以安装模块
if (-not(Get-Module -ListAvailable -Name MineStat)) {
    Write-Output "未安装 MineStat 模块。正在安装..."
    Install-Module -Name MineStat
}

Import-Module MineStat
$defaultAddress = Get-Item -Path .\address.txt | Get-Content
$address = ''
$port = 0
if ($null -eq $defaultAddress -or '' -eq $defaultAddress.Trim()) {
    Write-Output "提示：你可以在 address.txt 文件中设置默认服务器地址 (IPv4 地址:端口)"
    $address = (Read-Host "请输入服务器地址").Trim()
    $port = (Read-Host "请输入服务器端口").Trim()
} else {
    Write-Output "使用默认服务器地址: $defaultAddress"
    $address = $defaultAddress
    $port = $address.Split(":")[1]
    $address = $address.Split(":")[0]
}

$ms = MineStat -Address $address -Port $port

"正在获取 Minecraft 服务器 '{0}' 在端口 {1} 的状态：" -f $ms.Address, $ms.Port
try {
    if ($ms.Online) {
        "服务器版本: {0}" -f $ms.Version
        "服务器名称: {0}" -f $ms.Stripped_Motd
        "玩家数量: {0}/{1}" -f $ms.Current_Players, $ms.Max_Players
        "延迟: {0}ms" -f $ms.Latency
        "使用 SLP 协议 '{0}' 连接" -f $ms.Slp_Protocol
        Write-Host "按 Enter 键继续..."
        Read-Host
    } else {
        "服务器离线！"
        Write-Host "按 Enter 键继续..."
        Read-Host
    }
} catch {
    Write-Output "发生错误: $_"
    Write-Host "按 Enter 键继续..."
    Read-Host
}
