//%attributes = {}


$products:=ds:C1482.Products.all().toCollection()

$text:=JSON Stringify:C1217($products; *)

TEXT TO BLOB:C554($text; $blob)

$userManualFile:=File:C1566("/RESOURCES/products.json")

If ($userManualFile.exists)
	$userManualFile.delete()
End if 

$userManualFile.setContent($blob)

