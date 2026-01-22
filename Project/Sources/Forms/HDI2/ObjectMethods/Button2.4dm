

If (btnTrace)
	TRACE:C157
End if 


Form:C1466.products:=ds:C1482.Products.init()

LISTBOX SELECT ROW:C912(*; "LBProducts2"; 1; lk replace selection:K53:1)

Form:C1466.selectedProduct:=Form:C1466.products.first()

OBJECT SET ENABLED:C1123(*; "ToDeleteButton"; Form:C1466.selectedProduct#Null:C1517)
OBJECT SET ENABLED:C1123(*; "DropButton"; Form:C1466.selectedProduct#Null:C1517)