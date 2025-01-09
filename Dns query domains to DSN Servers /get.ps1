$Dns_File = "G:\Projectos\Dns query from domain to DSN Servers - Powershell\dns_servers.txt";
$IPAddress = [System.IO.File]::ReadAllLines($Dns_File)
## $File = "G:\Projectos\Dns query from domain to DSN Servers - Powershell\domains.txt";
## $Domains = [System.IO.File]::ReadAllLines($File)

foreach($ip in $IPAddress){
    $pingtest =  Resolve-DnsName -Server $ip -Type 0 -NoHostsFile -DnsOnly -Name s3t3d2y8.afcdn.net | Select-Object -ExpandProperty IPAddress
    $pingtest >> Ip_reply_DNS01.txt
    Write-Host "DNS Server: " $ip
    Write-Host "IP: " $pingtest
    Write-Host "---------------------------------------------------------------------------------"
}
