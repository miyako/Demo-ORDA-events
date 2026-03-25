//%attributes = {"invisible":true}
If (False:C215)
	
	//トークンを保存する
	
	$oAuth2:=SignedInProvider
	$token:=$oAuth2.getToken()
	
	cs:C1710.Utilities.me._setTokensForProvider("Google"; $token.token)
	
Else 
	
	$oAuth2:=SignedInProvider
	$oAuth2.getToken()
	
	var $mail:={}
	$mail.to:="fourdjapanprofessionalservices@gmail.com"
	$mail.sender:="fourdjapanprofessionalservices@gmail.com"
	$mail.subject:="テスト送信"
	$mail.textBody:=""
	$google:=cs:C1710.NetKit.Google.new($oAuth2; New object:C1471("mailType"; "JMAP"))
	$status:=$google.mail.send($mail)
	
End if 