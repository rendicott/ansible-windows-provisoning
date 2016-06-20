# Sets Static IP on Windows
#
# Needs parameter oldIp so we know which interface to modify
# this will help in situations later where there are multiple
# interfaces
#
# newMask - this parameter is set as a prefix rather than a mask
# (e.g., '24' instead of '255.255.255.0'
# 
# I think this only works on Windows8/2012 family OS's
#
#param(
#        [string]$oldIp,
#        [string]$newIp,
#        [string]$newMask,
#        [string]$newGateway,
#        [string]$newDNS1,
#        [string]$newDNS2
#)
## Taking out parameters and turning into a jinja template
$oldIp = '{{ oldIp }}'
$newIp = '{{ newIp }}'
$newMask = '{{ newMask }}'
$newGateway = '{{ newGateway }}'
$newDNS1 = '{{ newDNS1 }}'
$newDNS2 = '{{ newDNS2 }}'

$IPType = "IPv4"

# Retrieve the network adapter that you want to configure
$ipsearch = Get-NetIpAddress -IpAddress $oldIp
$adapterInterfaceNumber = $ipsearch.InterfaceIndex

$adapter = Get-NetAdapter -ifindex $adapterInterfaceNumber

# Remove any existing IP, gateway from our ipv4 adapter
If (($adapter | Get-NetIPConfiguration).IPv4Address.IPAddress) {
    $adapter | Remove-NetIPAddress -AddressFamily $IPType -Confirm:$false
}

If (($adapter | Get-NetIPConfiguration).Ipv4DefaultGateway) {
    $adapter | Remove-NetRoute -AddressFamily $IPType -Confirm:$false
}

 # Configure the IP address and default gateway
$adapter | New-NetIPAddress `
    -AddressFamily $IPType `
    -IPAddress $newIp `
    -PrefixLength $newMask `
    -DefaultGateway $newGateway

# Configure the DNS client server IP addresses
$adapter | Set-DnsClientServerAddress -ServerAddresses $newDNS1
$adapter | Set-DnsClientServerAddress -ServerAddresses $newDNS2
