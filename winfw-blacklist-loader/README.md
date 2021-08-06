# powershell-winfw-blacklist-loader
Powershell script to turn a blacklist text file into windows firewall ip block rules.

# running the script
Open a powershell console with elevated privileges.. 
PS> .\Load-Blacklist.ps1 -InputFile MyBlacklist.txt -Direction Both

(run: wf.msc, to check the rules and maybe enable logging)

# resources
some blacklists 
- https://blocklist.greensnow.co/greensnow.txt
- https://check.torproject.org/torbulkexitlist?ip=1.2.3.4
- http://lists.blocklist.de/lists/all.txt
- http://www.ciarmy.com/list/ci-badguys.txt
- https://www.binarydefense.com/banlist.txt