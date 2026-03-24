Class extends DataStoreImplementation

exposed Function authentify($credentials : Object) : Boolean
	
	var $user : cs:C1710.UsersEntity
	var $sale : cs:C1710.SalesPeopleEntity
	var $result:=False:C215
	
	If ((Session:C1714.storage.userInfo.salesId#Null:C1517) && Not:C34(Session:C1714.isGuest()))
		return True:C214
	End if 
	
	If ($credentials#Null:C1517)
		$user:=ds:C1482.Users.query("identifier === :1"; $credentials.identifier).first()
		If (($user#Null:C1517) && (Verify password hash:C1534($credentials.password; $user.password)))
			Session:C1714.clearPrivileges()
			Session:C1714.setPrivileges("forDemo")
			$sale:=$user.sales.first()
			Use (Session:C1714.storage)
				Session:C1714.storage.userInfo:=New shared object:C1526("salesId"; $sale.ID; "docsFolder"; $sale.docsPath; "marginThreshold"; $sale.marginThreshold; "adminEmail"; $sale.adminEmail)
			End use 
			$result:=True:C214
		End if 
	End if 
	
	If ($result=False:C215)
		Web Form:C1735.setError("不正な認証情報です。")
		throw:C1805(999; "不正な認証情報です。")
	Else 
		return $result
	End if 