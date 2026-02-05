

var $notDropped : cs:C1710.ProductsSelection


//00_Start

Use (Storage:C1525)
	Storage:C1525.diskInfo:=New shared object:C1526("noSpaceOnDisk"; False:C215)
	Storage:C1525.docMap:=New shared collection:C1527()
End use 


ds:C1482.authentify({identifier: "Ann"; password: "a"})

//$sale:=ds.SalesPeople.all().first()

//Use (Session.storage)
//Session.storage.userInfo:=New shared object("salesId"; $sale.ID; "docsFolder"; $sale.docsPath; "marginThreshold"; $sale.marginThreshold; "adminEmail"; $sale.adminEmail)
//End use 


$notDropped:=ds:C1482.Products.init()
