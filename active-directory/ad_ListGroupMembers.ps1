#Author: hdmn.net
#Purpose: Exports all Groups from Active Directory with it's Users and Manager

$serverName = ""				# "SERVERNAME"
$searchBase = ""				# "OU=Users,DC=domain,DC=local"
$csvPrefix  = "ADGroupMembers"

	if (!$serverName -OR !$searchBase) { Write-Host "Please specify Servername and Active Directory details in Script." -foregroundcolor red -backgroundcolor yellow; Exit } 
 
# path to output file
    $dateCaptured = (get-date -format s).Replace(":", "-")
    $csvPath = ".\" + $csvPrefix + "_" + $dateCaptured + ".csv"

	Import-Module ActiveDirectory

# project groups
    $groups=Get-ADGroup -Filter {Name -like '*'} -SearchBase $searchBase -server $serverName | select Name

# Generates a headline and writes it to the CSV file
    $csvHeaderRow = "GROUP NAME,GROUP MANAGER,USER ALIAS,USER NAME,USER LAST NAME,USER FIRST NAME,USER ACCOUNT ENABLED,DATE CAPTURED"
    $csvHeaderRow | Out-File $csvPath -Encoding "Default"

    $groupCollection = $groups.Name | sort-object
    $groupCount = $groupCollection.count


	Write-Host $groupCount.ToString("0").PadLeft(11) -foregroundcolor red -backgroundcolor yellow -nonewline
	Write-Host " Active Directory groups detected!"


	foreach ($groupName In $groupCollection) {
		$groupObject = Get-ADGroup -Identity $groupName -Properties Member,cn,managedBy -server $serverName
		$groupCN = $groupObject.cn
		
		# ManagedBy
			if ($groupObject.managedBy) {
				$groupManagerDN = $groupObject.managedBy
				$groupManagerSAMA = Get-ADObject -Identity $groupManagerDN -Properties sAMAccountName -server $serverName
				$groupManager = $groupManagerSAMA.sAMAccountName		
			} else {$groupManager = "-"}
			
		$memberCollection = $groupObject.Member | sort-object
		foreach ($distinguishedName In $memberCollection) {
			$userObject = Get-ADObject -Identity $distinguishedName -Properties cn,sn,givenName,sAMAccountName,enabled -server $serverName
			$userName = $userObject.cn
			$lastName = $userObject.sn
			$firstName = $userObject.givenName
			$sAMAccountName = $userObject.sAMAccountName

			# Account enabled? / ADObject doesn't give us the enabled-state of an User Account; so we're using Get-ADUser instead
				$accountEnabled = ""
				if ($userObject.ObjectClass -Eq "user") {
					$userEnabled = Get-ADUser -Identity $distinguishedName -Properties enabled -server $serverName
					 if ($userEnabled.enabled -Eq "True") {
						$accountEnabled = "enabled"
					 } else {$accountEnabled = "disabled"}
				}
					
			# output of current line to CSV
				$csvRow = "$groupCN,$groupManager,$sAMAccountName,$userName,$lastName,$firstName,$accountEnabled,$dateCaptured"
				$csvRow | Out-File $csvPath -Append -Encoding "Default"
		}		
		
		# funny console output optimization
			$percentage = ($i++/$groupCount*100).ToString("0").PadLeft(10)
			Write-Host ("$percentage" + "%" + " - " + "$groupCN") -foregroundcolor gray
	}
