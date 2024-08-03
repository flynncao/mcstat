# Run `Install Module MineStat` first to install the module
if (-not(Get-Module -ListAvailable -Name MineStat)) {
	Write-Output "Module MineStat is not installed. Installing..."
	Install-Module -Name MineStat
}

Import-Module MineStat
$defaultAddress = Get-Item -Path .\address.txt | Get-Content
$address = ''
$port = 0
if ($null -eq $defaultAddress -or '' -eq $defaultAddress.Trim() ) {
	Write-Output "Notice: You can set the default server address (ipv4 address:port) in address.txt"
	$address = (Read-Host "Enter the server address").Trim()
	$port = (Read-Host "Enter the server port").Trim()
}
else {
	Write-Output "Using default server address: $defaultAddress"
	$address = $defaultAddress
	$port = $address.Split(":")[1]
	$address = $address.Split(":")[0]
}


$ms = MineStat -Address $address -port $port

"Getting Minecraft server status of '{0}' on port {1}:" -f $ms.Address, $ms.Port
try {
	if ($ms.Online) {
		"Server Version: {0}" -f $ms.Version
		"Server Name: {0}" -f $ms.Stripped_Motd
		"Players: {0}/{1}" -f $ms.Current_Players, $ms.Max_Players
		"Latency: {0}ms" -f $ms.Latency
		"Connected using SLP protocol '{0}'" -f $ms.Slp_Protocol
		Write-Host "Press Enter to continue..."
		Read-Host
		"Latency: {0}ms" -f $ms.Latency
		"Connected using SLP protocol '{0}'" -f $ms.Slp_Protocol
		Write-Host "Press Enter to continue..."
		Read-Host
	}
	else {
		"Server is offline!"
		Write-Host "Press Enter to continue..."
		Read-Host
	}
}
catch {
	<#Do this if a terminating exception happens#>
	Write-Output "An error occurred: $_"
	Write-Host "Press Enter to continue..."
	Read-Host
}
