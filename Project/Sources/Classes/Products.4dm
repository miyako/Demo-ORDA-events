Class extends DataClass

Function event restrict() : cs:C1710.ProductsSelection
	
	var $result : cs:C1710.ProductsSelection
	
	If (Session:C1714#Null:C1517)
		If (Session:C1714.hasPrivilege("WebAdmin"))  // Data Explorer
			$result:=Null:C1517
		Else 
			If (Session:C1714.storage.userInfo.salesId#Null:C1517)
				$result:=ds:C1482.SalesPeople.get(Session:C1714.storage.userInfo.salesId).products
			End if 
		End if 
	End if 
	
	return $result
	
exposed Function getNew() : cs:C1710.ProductsEntity
	
	return This:C1470.new()