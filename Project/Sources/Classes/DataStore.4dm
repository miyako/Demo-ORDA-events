Class extends DataStoreImplementation


exposed Function authentify($credentials : Object) : Boolean
	
	var $user : cs:C1710.UsersEntity
	var $sale : cs:C1710.SalesPeopleEntity
	var $result:=False:C215
	
	//
	// Check if the session is already authenticated
	//
	If ((Session:C1714.storage.userInfo.salesId#Null:C1517) && Not:C34(Session:C1714.isGuest()))
		return True:C214
	End if 
	
	
	If ($credentials#Null:C1517)
		//
		//The session is not authenticated - Identify the user with their credentials
		//
		$user:=ds:C1482.Users.query("identifier === :1"; $credentials.identifier).first()
		
		If (($user#Null:C1517) && (Verify password hash:C1534($credentials.password; $user.password)))
			Session:C1714.clearPrivileges()
			Session:C1714.setPrivileges("forDemo")
			
			$sale:=$user.sales.first()
			
			Use (Session:C1714.storage)
				Session:C1714.storage.userInfo:=New shared object:C1526("salesId"; $sale.ID; "docsFolder"; $sale.docsPath; "marginThreshold"; $sale.marginThreshold)
			End use 
			
			$result:=True:C214
			
		End if 
		
	End if 
	
	If ($result=False:C215)
		//
		// The session is not authenticated
		// An error is thrown to prevent the navigation from the Authentication page to the Main page
		//
		throw:C1805(999; "Wrong credentials")
	Else 
		return $result
	End if 