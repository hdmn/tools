'Author: hdmn.net
'Purpose: An easy way to copy the content of one LDAP-Attribute to another. 
'Caution: OVERWRITES existing values in target Attribute!

On Error Resume Next
Const ADS_SCOPE_SUBTREE = 2
Set objConnection = CreateObject("ADODB.Connection")
Set objCommand =   CreateObject("ADODB.Command")
objConnection.Provider = "ADsDSOObject"
objConnection.Open "Active Directory Provider"
Set objCommand.ActiveConnection = objConnection
objCommand.Properties("Page Size") = 1000
objCommand.Properties("Searchscope") = ADS_SCOPE_SUBTREE 
objCommand.CommandText = "SELECT AdsPath FROM 'LDAP://OU=Users,DC=domain,DC=local' WHERE objectCategory='user'"  
Set objRecordSet = objCommand.Execute
objRecordSet.MoveFirst
Do Until objRecordSet.EOF
    Set objUser = GetObject(objRecordSet.Fields("AdsPath").Value)
    physicalDeliveryOfficeName = objUser.physicalDeliveryOfficeName
    objUser.title = physicalDeliveryOfficeName
    objUser.SetInfo
    objRecordSet.MoveNext
Loop
