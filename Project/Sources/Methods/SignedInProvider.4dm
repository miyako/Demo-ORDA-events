//%attributes = {}
#DECLARE : cs:C1710.NetKit.OAuth2Provider

var $param : Object
$param:=cs:C1710.Utilities.me._getSettingsForProvider("Google")

//var $oAuth2 : cs.NetKit.OAuth2Provider
//$oAuth2:=cs.NetKit.OAuth2Provider.new($param)
//$token:=$oAuth2.getToken()
//cs.Utilities.me._setTokensForProvider("Google"; $token)

$param.authenticationPage:=Folder:C1567(fk web root folder:K87:15).file("authentication.htm")
$param.authenticationErrorPage:=Folder:C1567(fk web root folder:K87:15).file("error.htm")

$param.accessType:="offline"
$param.token:=cs:C1710.Utilities.me._getTokensForProvider("Google")

// Create new OAuth2 object
return cs:C1710.NetKit.OAuth2Provider.new($param)