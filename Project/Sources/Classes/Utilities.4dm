

session singleton Class constructor()
	
	
	
exposed Function getSalesPeople() : cs:C1710.SalesPeopleEntity
	
	return ds:C1482.SalesPeople.get(Session:C1714.storage.userInfo.salesId)
	
	
	
exposed Function resetSessionStorage()
	
	Use (Session:C1714.storage)
		Session:C1714.storage.userInfo:=New shared object:C1526("salesId"; Null:C1517)
	End use 