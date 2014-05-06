'Author: hdmn.net
'Purpose: Exports AD-Users with Attribute "homePhone" to ADusers.csv in the folder of this Script

Set oConnection = CreateObject("ADODB.Connection")
Set oRecordset = CreateObject("ADODB.Recordset")
Set oCommand = CreateObject("ADODB.Command")
oConnection.Provider = "ADsDSOObject"  'The ADSI OLE-DB provider
oConnection.Open "ADs Provider"
oCommand.ActiveConnection = oConnection
oCommand.Properties("Page Size") = 1000
oCommand.CommandText = "<LDAP://OU=Users,DC=domain,DC=local>;" & _
	"(homePhone=*);" & _
	"sn,givenName,name,sAMAccountName,telephoneNumber,facsimileTelephoneNumber,homePhone,mail,title,physicalDeliveryOfficeName,whenCreated,company" & _
	";subtree"
Set oRecordset = oCommand.Execute
wscript.echo "Done Total Records found:" & oRecordset.recordcount
Set fs = CreateObject("Scripting.FileSystemObject")
Set output = fs.CreateTextFile("ADusers.csv")
output.write Chr(34) & "Anrede" & Chr(34) & "," & Chr(34) & "Vorname" & Chr(34) & "," & Chr(34) & "Nachname" & Chr(34) & "," & Chr(34) & "Firma" & Chr(34) & "," & Chr(34) & "Position" & Chr(34) & "," & Chr(34) & "Faxgeschäftlich" & Chr(34) & "," & Chr(34) & "Telefongeschäftlich" & Chr(34) & "," & Chr(34) & "Telefonprivat" & Chr(34) & "," & Chr(34) & "EMailAdresse" & Chr(34) & "," & Chr(34) & "EMailTyp" & Chr(34) & "," & Chr(34) & "EMailAngezeigterName" & Chr(34) & "," & Chr(34) & "Notizen" & Chr(34) & vbCrLf
do until oRecordset.EOF
	output.write Chr(34) & oRecordset.Fields("title") & Chr(34) & "," & _
	 Chr(34) & oRecordset.Fields("givenName") & Chr(34) & "," & _
	 Chr(34) & oRecordset.Fields("sn") & Chr(34) & "," & _
	 Chr(34) & oRecordset.Fields("company") & Chr(34) & "," & _
	 Chr(34) & oRecordset.Fields("physicalDeliveryOfficeName") & Chr(34) & "," & _
	 Chr(34) & "+49 _prefix_ " & oRecordset.Fields("facsimileTelephoneNumber") & Chr(34) & "," & Chr(34)
	'telephoneNumber & homePhone nur einbeziehen, wenn mit korrekten Daten befüllt
	telephoneNumber = oRecordset.Fields("telephoneNumber")
		if len(telephoneNumber) > 2 then			
			output.write "+49 _prefix_ " & oRecordset.Fields("telephoneNumber")
		end if
	output.write Chr(34) & "," & Chr(34) 
	homePhone = oRecordset.Fields("homePhone")
		if len(homePhone) > 2 then
			'führende 0 abschneiden und durch +49 ersetzen
			homePhone = right(homePhone, len(homePhone) - 1)
			output.write "+49 " & homePhone
		end if
	output.write Chr(34) & "," & Chr(34) & oRecordset.Fields("mail") & Chr(34) & "," & _
	 Chr(34) & "SMTP" & Chr(34) & "," & _
	 Chr(34) & oRecordset.Fields("givenName") & " " & oRecordset.Fields("sn") & "(" & oRecordset.Fields("mail") & ")" & Chr(34) & "," & _
	 Chr(34) & oRecordset.Fields("sAMAccountName") & Chr(34) & "," & _
	 Chr(34) & oRecordset.Fields("whenCreated") & Chr(34) & _
	 vbCrLf
oRecordset.MoveNext
loop
