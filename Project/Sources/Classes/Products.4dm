Class extends DataClass



Function event restrict() : cs:C1710.ProductsSelection
	
	var $result : cs:C1710.ProductsSelection
	
	
	If (Session:C1714#Null:C1517)
		
		If (Session:C1714.hasPrivilege("WebAdmin"))
			$result:=Null:C1517
		Else 
			$result:=ds:C1482.SalesPeople.get(Session:C1714.storage.userInfo.salesId).products
		End if 
		
	End if 
	
	return $result
	
	
	//exposed Function init() : cs.ProductsSelection
	
	//var $productsFile : 4D.File
	//var $productsColl : Collection
	//var $products; $notDropped : cs.ProductsSelection
	//var $product : cs.ProductsEntity
	//var $status : Object
	//var $blob : Blob
	
	
	
	
	//$notDropped:=This.all().drop()
	
	//$productsFile:=File("/PACKAGE/Resources/products.json")
	//$productsColl:=JSON Parse($productsFile.getText())
	
	
	//Use (Storage.docMap)
	//For each ($product; $productsColl)
	//TEXT TO BLOB("This is the "+$product.name+" user manual"; $blob)
	//Storage.docMap.push(New shared object("name"; $product.name; "content"; $blob))
	//End for each 
	//End use 
	
	//$products:=This.fromCollection($productsColl)
	
	//return $products
	
	// ---------------------------------------------
	//
	//For Qodly
	//
exposed Function getNew() : cs:C1710.ProductsEntity
	return This:C1470.new()
	
	
	