#Author: hdmn.net
#Purpose: Exports static & dynamic Distribution Groups from Exchange / Active Directory with all it's Users

add-pssnapin Microsoft.Exchange.Management.PowerShell.E2010
$dateCaptured = (get-date -format s).Replace(":", "-")
$csvFilePath = ".\distributionlists_$dateCaptured.csv" 
$resultset = @()

# DynamicDistributionGroup 
	$distributionlists = Get-DynamicDistributionGroup -Identity * | select displayName,LdapRecipientFilter,RecipientContainer,PrimarySMTPAddress 
	foreach ($singledistributionlist in $distributionlists) {
		$recipients = @()
		$members = @()
		$recipients += Get-Recipient -RecipientPreviewFilter $singledistributionlist.LdapRecipientFilter -OrganizationalUnit $singledistributionlist.RecipientContainer | select recipientType,displayName,PrimarySMTPAddress
		foreach ($member in $recipients) {
			$entry = new-object psobject
			$entry |Add-Member -MemberType noteproperty -Name "list-GroupType" -value "Dynamic"
			$entry |Add-Member -MemberType noteproperty -Name "list-displayName" -value $singledistributionlist.displayName
			$entry |Add-Member -MemberType noteproperty -Name "list-PrimarySMTPAddress" -value $singledistributionlist.PrimarySMTPAddress
			$entry |Add-Member -MemberType noteproperty -Name "member-recipientType" -value $member.recipientType
			$entry |Add-Member -MemberType noteproperty -Name "member-displayName" -value $member.displayName
			$entry |Add-Member -MemberType noteproperty -Name "member-PrimarySMTPAddress" -value $member.PrimarySMTPAddress
			$members += $entry
		}
		$resultset += $members
	}

# DistributionGroup
	$distributionlists = Get-DistributionGroup -Identity * 
	foreach ($singledistributionlist in $distributionlists) {
		$recipients = @()
		$members = @()
		$recipients += Get-DistributionGroupMember -Identity $singledistributionlist | select recipientType,displayName,PrimarySMTPAddress
		foreach ($member in $recipients) {
			$entry = new-object psobject
			$entry |Add-Member -MemberType noteproperty -Name "list-GroupType" -value $singledistributionlist.GroupType
			$entry |Add-Member -MemberType noteproperty -Name "list-displayName" -value $singledistributionlist.displayName
			$entry |Add-Member -MemberType noteproperty -Name "list-PrimarySMTPAddress" -value $singledistributionlist.PrimarySMTPAddress
			$entry |Add-Member -MemberType noteproperty -Name "member-recipientType" -value $member.recipientType
			$entry |Add-Member -MemberType noteproperty -Name "member-displayName" -value $member.displayName
			$entry |Add-Member -MemberType noteproperty -Name "member-PrimarySMTPAddress" -value $member.PrimarySMTPAddress
			$members += $entry
		}
		$resultset += $members
	}
$resultset | export-csv $csvFilePath -NoTypeInformation -encoding default
