

session singleton Class constructor()
	
	
	
exposed Function getSalesPeople() : cs:C1710.SalesPeopleEntity
	
	return ds:C1482.SalesPeople.get(Session:C1714.storage.userInfo.salesId)
	
	
	
exposed Function resetSessionStorage()
	
	Use (Session:C1714.storage)
		Session:C1714.storage.userInfo:=New shared object:C1526("salesId"; Null:C1517)
	End use 
	
	
exposed Function sendMailAlert($sendTo : Text)
	
	
	var $oAuth2 : cs:C1710.NetKit.OAuth2Provider
	var $google : cs:C1710.NetKit.Google
	var $status : Object
	var $mail:={}
	
	
	$oAuth2:=SignedInProvider
	$oAuth2.getToken()
	
	
	If ($sendTo#"")
		$mail.to:=$sendTo
		$mail.sender:="4ddemos@gmail.com"
		$mail.subject:="No more space on disk in "+Session:C1714.storage.userInfo.docsFolder
		$mail.textBody:=""
		
		// Creates a provider to send an email in Google format
		$google:=cs:C1710.NetKit.Google.new($oAuth2; New object:C1471("mailType"; "JMAP"))
		
		// Send the email
		$status:=$google.mail.send($mail)
		
		//If ($status.success)
		//Web Form.setMessage("An email has been sent! Go to your mail box")
		//End if 
		
	End if 