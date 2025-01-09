###
## Add all rules inbound/outbound to Windows Firewall
####
Write-Host "#################################################################################"
Write-Host "Add all rules Allow and Block (inbound/outbound) Ip Address to Windows Firewall"
Write-Host "#################################################################################"
    try {
        # invoke the worker script
        Write-Host "---------------------------------------------------------------------------------"
        Write-Host "Add all rules Allow (inbound) Ip Address to Windows Firewall"
        Write-Host "---------------------------------------------------------------------------------"

        $Path = "G:\Projectos\Dns query from domain to DSN Servers - Powershell\"
        $Source = "dns_servers.txt"
        $SourceFile = $Path + $Source
        $sw = new-object System.Diagnostics.Stopwatch
        $sw.Start()
        Write-Host "Reading source file..."
        $lines = [System.IO.File]::ReadAllLines($SourceFile)
        $totalLines = $lines.Length
        
        Write-Host "Total Ip Address to add Allow Inbound :" $totalLines
        
        $skip = 0
        $count = 10000; # Number of lines per file
        
        # File counter, with sort friendly name
        $fileNumber = 1
        $fileNumberString = $filenumber.ToString("000")
        
        while ($skip -le $totalLines) {
            $upper = $skip + $count - 1
            if ($upper -gt ($lines.Length - 1)) {
                $upper = $lines.Length - 1
            }
        
            # Write the lines
            $FileSource = $Path + "result" + $fileNumberString + ".txt"
            [System.IO.File]::WriteAllLines($FileSource,$lines[($skip..$upper)])
        
            # Add firewall rules
        ##    $IPAddress = get-Content -Path "G:\Tools-Herramientas(Software)\HOSTS-Windows_Firewall\Add_Windows_Firewall\result$fileNumberString.txt"
        ##    New-NetFirewallRule -DisplayName "Block WebSites$fileNumberString" -Direction Outbound –LocalPort Any -Protocol Any -Action Block -RemoteAddress $IPAddress
        ##    New-NetFirewallRule -DisplayName "Block WebSites$fileNumberString" -Direction Inbound –LocalPort Any -Protocol Any -Action Block -RemoteAddress $IPAddress
        
            # Increment counters
        ##    Remove-Item "G:\Tools-Herramientas(Software)\HOSTS-Windows_Firewall\Add_Windows_Firewall\result$fileNumberString.txt"
            $skip += $count
            $fileNumber++
            $fileNumberString = $filenumber.ToString("000")
        }

        $sw.Stop()
        
        Write-Host "Split complete in " $sw.Elapsed.TotalSeconds "seconds"
        
        $fileNumber = $fileNumber -1

        ## 1..$fileNumber | ForEach-Object { "Hello $_"; sleep 0 }
        1..$fileNumber | ForEach-Object -Parallel {
            $Path = "G:\Projectos\Dns query from domain to DSN Servers - Powershell\"
            $_ = $_.ToString("000")
            $IPFile = "result$_.txt";
            $IPSource = $Path + $IPFile
            $IPAddress = [System.IO.File]::ReadAllLines($IPSource)
            Remove-NetFirewallRule -DisplayName "Allow Outbound DNS Servers-$_";
##            New-NetFirewallRule -DisplayName "Allow Ips$_" -Direction Outbound –LocalPort Any -Protocol Any -Action Allow -RemoteAddress $IPAddress;
            New-NetFirewallRule -DisplayName "Allow Outbound DNS Servers-$_" -Direction Outbound –LocalPort Any -Protocol Any -Action Allow -RemoteAddress $IPAddress;
            Remove-Item $IPSource;
            Start-Sleep 0; } -ThrottleLimit 10
            
        #1..$fileNumber | ForEach-Object -Parallel {
        #    Remove-Item $Path\result$_.txt";
        #    sleep 0; } -ThrottleLimit 10
    }
    catch {
        # do something with $_, log it, more likely
    }
#################################################################################
