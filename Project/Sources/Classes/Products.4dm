Class extends DataClass




exposed Function init() : cs:C1710.ProductsSelection
	
	var $productsFile : 4D:C1709.File
	var $productsColl : Collection
	var $products; $notDropped : cs:C1710.ProductsSelection
	var $product : cs:C1710.ProductsEntity
	var $status : Object
	var $blob : Blob
	
	
	
	
	$notDropped:=This:C1470.all().drop()
	
	$productsFile:=File:C1566("/PACKAGE/Resources/products.json")
	$productsColl:=JSON Parse:C1218($productsFile.getText())
	
	
	Use (Storage:C1525.docMap)
		For each ($product; $productsColl)
			TEXT TO BLOB:C554("This is the "+$product.name+" user manual"; $blob)
			Storage:C1525.docMap.push(New shared object:C1526("name"; $product.name; "content"; $blob))
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
	
	
	