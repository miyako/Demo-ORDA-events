

var $status : Object


If (btnTrace)
	TRACE:C157
End if 


Form:C1466.selectedProduct.status:="TO DELETE"

$status:=Form:C1466.selectedProduct.save()

Form:C1466.products:=Form:C1466.products

OBJECT SET VISIBLE:C603(*; "Message2"; True:C214)
OBJECT SET VISIBLE:C603(*; "Info2"; True:C214)

Form:C1466.info:="You can now drop this product"
Form:C1466.message:=""

OBJECT SET RGB COLORS:C628(*; "Message2"; "#000000")
OBJECT SET RGB COLORS:C628(*; "Info2"; "#000000")

OBJECT SET ENABLED:C1123(*; "ToDeleteButton"; Form:C1466.selectedProduct#Null:C1517)
OBJECT SET ENABLED:C1123(*; "DropButton"; Form:C1466.selectedProduct#Null:C1517)






