session singleton Class constructor()
	
Function _secretsFolder() : 4D:C1709.Folder
	
	return Folder:C1567("/PACKAGE/Secrets")
	
Function _setTokensForProvider($provider : Text; $tokens : Object)
	
	If ($provider="") || ($tokens=Null:C1517)
		return 
	End if 
	
	var $file : 4D:C1709.File
	$file:=This:C1470._secretsFolder().file($provider+".json")
	$file.setText(JSON Stringify:C1217($tokens; *))
	
Function _getTokensForProvider($provider : Text) : Object
	
	var $file : 4D:C1709.File
	$file:=This:C1470._secretsFolder().file($provider+".json")
	return $file.exists ? Try(JSON Parse:C1218($file.getText(); Is object:K8:27)) : Null:C1517
	
Function _setSettingsForProvider($provider : Text; $settings : Object)
	
	If ($provider="") || ($settings=Null:C1517)
		return 
	End if 
	
	var $file : 4D:C1709.File
	$file:=This:C1470._secretsFolder().file($provider+"-settings.json")
	$file.setText(JSON Stringify:C1217($settings; *))
	
Function _getSettingsForProvider($provider : Text) : Object
	
	var $file : 4D:C1709.File
	$file:=This:C1470._secretsFolder().file($provider+"-settings.json")
	return $file.exists ? Try(JSON Parse:C1218($file.getText(); Is object:K8:27)) : Null:C1517
	
exposed Function getSalesPeople() : cs:C1710.SalesPeopleEntity
	
	return ds:C1482.SalesPeople.get(Session:C1714.storage.userInfo.salesId)
	
exposed Function docsPath() : Text
	
	return Session:C1714.storage.userInfo.docsFolder
	
exposed Function resetSessionStorage()
	
	Use (Session:C1714.storage)
		Session:C1714.storage.userInfo:=New shared object:C1526("salesId"; Null:C1517)
	End use 
	
exposed Function sendMailAlert($sendTo : Text)->$status : Object
	
	var $oAuth2 : cs:C1710.NetKit.OAuth2Provider
	var $google : cs:C1710.NetKit.Google
	var $mail:={}
	
	$oAuth2:=SignedInProvider
	$oAuth2.getToken()
	
	If ($sendTo#"")
		$mail.to:=$sendTo
		$mail.sender:="fourdjapanprofessionalservices@gmail.com"
		$mail.subject:="No more space on disk in "+Session:C1714.storage.userInfo.docsFolder
		$mail.textBody:=""
		$google:=cs:C1710.NetKit.Google.new($oAuth2; New object:C1471("mailType"; "JMAP"))
		$status:=$google.mail.send($mail)
	End if 