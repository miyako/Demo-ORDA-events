//%attributes = {}
// Creates the object that contains all the information for the OAuth2 connection 
#DECLARE : cs:C1710.NetKit.OAuth2Provider

var $param : Object

$param:=New object:C1471()
$param.name:="Google"
$param.permission:="signedIn"
$param.clientId:="792232410512-coek5kt09vvtnsofh34i09j2fadietrg.apps.googleusercontent.com"
$param.clientSecret:="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"
$param.redirectURI:="http://127.0.0.1:50993/authorize/"
$param.scope:="https://www.googleapis.com/auth/gmail.send"

// Successful authentication page
$param.authenticationPage:=Folder:C1567(fk web root folder:K87:15).file("authentication.htm")
// Error authentication page
$param.authenticationErrorPage:=Folder:C1567(fk web root folder:K87:15).file("error.htm")

$param.accessType:="offline"
$param.token:=ds:C1482.Token.all().first().theToken

// Create new OAuth2 object
return cs:C1710.NetKit.OAuth2Provider.new($param)