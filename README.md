# Invoke-PortScanNG

Small function around [Invoke-PortScan](https://github.com/PowerShellMafia/PowerSploit/blob/master/Recon/Invoke-Portscan.ps1) and [PowerView](https://github.com/PowerShellMafia/PowerSploit/blob/master/Recon/PowerView.ps1) from PowerSploit.

# Why?
During labs I found myself scanning all the hosts again and again from each machine compromised. It irritated me that I had to create the ports and hosts file all the time, so I decided to create my own function to do this for me and start the portscan in one command. 

Running `Invoke-PortScanNG` will: 
- Request all computers from the current domain with `Get-DomainComputer` using the current logon. 
- Write them to `C:\users\public\computers.txt`
- Write the ports `22, 80, 443, 139, 445, 3389, 5985` to `C:\users\public\ports.txt`. 
- Scan them with `Invoke-PortScan` 
- Export it to the csv file in `C:\users\public\scandata_all.csv`
- Outputs the discovered hosts and open ports. 

# Usage
- Load PowerView
- Load Invoke-PortScan
- Run `Invoke-PortScanNG`
