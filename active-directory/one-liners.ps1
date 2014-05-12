#Author: hdmn.net
#Purpose: A collection of commands and one-liners I need from time to time


# Displays all User accounts and the date of the last Password change
Get-ADUser -filter {SamAccountName -like '*'}  -properties Name,PasswordLastSet | select Name,PasswordLastSet | ft

# Exports all User accounts and their Creation date 
# (user, mitarbeiter, account, anlegen, created, datum, alter, accountalter)
Get-ADUser -filter {SamAccountName -like '*'} -properties whenCreated,SamAccountName,GivenName,Surname | select whenCreated,SamAccountName,GivenName,Surname | sort-object whenCreated | export-csv whenCreated.csv
