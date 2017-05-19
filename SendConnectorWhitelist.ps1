Invoke-Expression "& `"C:\SecureEmailScript\wget.exe`" --no-check-certificate -e https_proxy=PROXYIPHERE ""https://domaininformation.service.gov.uk/white-list/export?separator=newline"" -O C:\SecureEmailScript\whitelistnl.txt"

Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010

#We use a Static TLS connector (unused by exchange) to hold the names of static entries not on the whitelist - like *.gcsx.gov.uk etc.
$al = (Get-SendConnector -Identity "THE NAME OF YOUR STATIC TLS SEND CONNECTOR").AddressSpaces

$domains=Get-Content "C:\SecureEmailScript\whitelistnl.txt"
 
 #This just checks if the .txt file contains a minumum of 30 entries - in case the wget fails, or the website is haywire
 if ($domains.Count -gt 30) {

 foreach ($domain in $domains) {
 #this checks to make sure you dont add your own domain to the TLS send connector
 if ($domain -ne 'YOURDOMAIN.gov.uk') {
 #we use a priority of 2 in our send connector, but you can use any number you want here
    $formatted = "$domain;2"
	$al += $formatted
	}
 }

#This is the name of your final used TLS send connector
Set-SendConnector "THE NAME OF YOUR TLS SEND CONNECTOR" -AddressSpace $al
}