

var $notDropped : cs:C1710.ProductsSelection


//00_Start

Use (Storage:C1525)
	Storage:C1525.diskInfo:=New shared object:C1526("noSpaceOnDisk"; False:C215)
	Storage:C1525.docMap:=New shared collection:C1527()
End use 


$notDropped:=ds:C1482.Products.all().drop()
