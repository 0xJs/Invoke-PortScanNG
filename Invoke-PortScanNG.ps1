Function Invoke-PortScanNG {
<#
.SYNOPSIS
Author: Jony Schats - 0xjs
Required Dependencies: Get-DomainComputer, Invoke-Portscan
Optional Dependencies: None

.DESCRIPTION
Retrieve the computerobjects of the domain and scan ports 22, 80, 443, 139, 445, 3389, 5985

.PARAMETER OutputDirectory
Specifies the path to use for the output directory, defaults to C:\users\public\

.EXAMPLE
Invoke-PortScanNG

.EXAMPLE
Invoke-PortScanNG
#>
	[cmdletbinding()]
	param(
		[Parameter(Mandatory=$false)]
		[ValidateNotNullOrEmpty()]
		[string]$OutputDirectory
	)
	
	Begin{
		if ($OutputDirectory) {
			$Directory = $OutputDirectory
		}
		else {
			$Directory = "C:\users\public\"
		}
	}
	
	Process {
		$Computers = Get-DomainComputer | Select-Object dnshostname
		
		$HostsFile = "$Directory\computers.txt"
		$Computers | Out-File -Encoding utf8 $File
		$Computers = Get-Content $file
		$Computers = $Computers -replace 'dnshostname', '' -replace '-----------', '' #remove strings
		$Computers = $Computers.Trim() | ? {$_.trim() -ne "" } #Remove spaces and white lines
		$Computers | Out-File -Encoding utf8 $HostsFile
		
		$PortsFile = "$Directory\ports.txt"
		$Ports = "22
		80
		443
		139
		445
		1433
		3389
		5985"
		$Ports | Out-File -Encoding utf8 $PortFile
		
		$ScanFile = "$Directory\scandata_all.csv"
		Invoke-Portscan -HostFile $HostsFile -PortFile $PortsFile -SkipDiscovery -ErrorAction silentlycontinue | Export-Csv -Path $ScanFile
		
		$HostAliveFile = "$Directory\scandata_hostalive.csv"
		$HostAlive = Import-Csv -Path $ScanFile | Where-Object -Property openPorts | Select-Object Hostname, openPorts 
		$HostAlive | Export-Csv -Path $HostAliveFile
	}
	
	end {
		Return $HostAlive | Sort-Object -Property dnshostname
	}
}
