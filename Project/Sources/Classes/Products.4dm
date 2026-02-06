Class extends DataClass



Function event restrict() : cs:C1710.ProductsSelection
	
	var $result : cs:C1710.ProductsSelection
	
	
	If (Session:C1714#Null:C1517)
		
		If (Session:C1714.hasPrivilege("WebAdmin"))
			$result:=Null:C1517
		Else 
			If (Session:C1714.storage.userInfo.salesId#Null:C1517)
				$result:=ds:C1482.SalesPeople.get(Session:C1714.storage.userInfo.salesId).products
			End if 
		End if 
		
	End if 
	
	return $result
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
exposed Function init() : cs:C1710.ProductsSelection
	
	var $productsFile : 4D:C1709.File
	var $folder : 4D:C1709.Folder
	var $productsColl : Collection
	var $products; $notDropped : cs:C1710.ProductsSelection
	var $product : Object
	var $blob : Blob
	
	
	$notDropped:=This:C1470.all().drop()
	
	$folder:=Folder:C1567("/PACKAGE/docsForAnn/")
	$folder.delete(Delete with contents:K24:24)
	
	$folder:=Folder:C1567("/docsForArthur/")
	$folder.delete(Delete with contents:K24:24)
	
	
	$productsFile:=File:C1566("/PACKAGE/Resources/products.json")
	$productsColl:=JSON Parse:C1218($productsFile.getText())
	
	Use (Storage:C1525)
		Storage:C1525.docMap:=New shared collection:C1527()
	End use 
	
	Use (Storage:C1525.docMap)
		For each ($product; $productsColl)
			TEXT TO BLOB:C554("These are the "+$product.name+" product guidelines"; $blob)
			Storage:C1525.docMap.push(New shared object:C1526("name"; $product.name; "salesId"; ds:C1482.SalesPeople.all().first().ID; "content"; $blob))
		End for each 
	End use 
	
	$products:=This:C1470.fromCollection($productsColl)
	
	return $products
	
	// ---------------------------------------------
	//
	//For Qodly
	//
exposed Function getNew() : cs:C1710.ProductsEntity
	return This:C1470.new()
	
	
	