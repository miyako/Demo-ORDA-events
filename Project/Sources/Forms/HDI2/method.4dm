Case of 
		
	: (Form event code:C388=On Load:K2:1)
		
		btnTrace:=False:C215
		
		InitInfo
		
		Form:C1466.products:=ds:C1482.Products.init()
		
		
	: (Form event code:C388=On Page Change:K2:54)
		
		Form:C1466.products:=ds:C1482.Products.init()
		
		LISTBOX SELECT ROW:C912(*; "LBProducts2"; 1; lk replace selection:K53:1)
		
		OBJECT SET ENABLED:C1123(*; "ToDeleteButton"; Form:C1466.selectedProduct#Null:C1517)
		OBJECT SET ENABLED:C1123(*; "DropButton"; Form:C1466.selectedProduct#Null:C1517)
		
	: (Form event code:C388=On Close Box:K2:21)
		If (Is Windows:C1573 && Application info:C1599().SDIMode)
			QUIT 4D:C291
		Else 
			CANCEL:C270
		End if 
		
End case 