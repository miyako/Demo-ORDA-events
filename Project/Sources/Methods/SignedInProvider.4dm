//%attributes = {}
#DECLARE : cs:C1710.NetKit.OAuth2Provider

var $param : Object
$param:=cs:C1710.Utilities.me._getSettingsForProvider("Google")
$param.authenticationPage:=Folder:C1567(fk web root folder:K87:15).file("authentication.htm")
$param.authenticationErrorPage:=Folder:C1567(fk web root folder:K87:15).file("error.htm")

$param.accessType:="offline"
$param.token:=cs:C1710.Utilities.me._getTokensForProvider("Google")

//毎回リフレッシュトークンを使用する
$param.token.expires_in:=0

return cs:C1710.NetKit.OAuth2Provider.new($param)