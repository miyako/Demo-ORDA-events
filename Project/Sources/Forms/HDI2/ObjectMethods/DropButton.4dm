

If (btnTrace)
	TRACE:C157
End if 


Try
	Form:C1466.status:=Form:C1466.selectedProduct.drop()
Catch
	// Serious error
	OBJECT SET RGB COLORS:C628(*; "Message2"; "#ff0000")
	OBJECT SET RGB COLORS:C628(*; "Info2"; "#ff0000")
End try

If (Form:C1466.status.errors#Null:C1517)
	Form:C1466.info:=Form:C1466.status.errors.first().extraDescription.info
	Form:C1466.message:=Form:C1466.status.errors.first().message
	
	If (Form:C1466.status.errors.first().seriousError=False:C215)
		OBJECT SET RGB COLORS:C628(*; "Message2"; "#ff9933")
		OBJECT SET RGB COLORS:C628(*; "Info2"; "#ff9933")
	End if 
	
Else 
	Form:C1466.message:="The product has been successfully dropped"
	Form:C1466.info:="Congratulations!"
	
	Form:C1466.products:=Form:C1466.products.clean()
	
	OBJECT SET RGB COLORS:C628(*; "Message2"; "#009933")
	OBJECT SET RGB COLORS:C628(*; "Info2"; "#009933")
	
	LISTBOX SELECT ROW:C912(*; "LBProducts2"; 1; lk replace selection:K53:1)
	
	If (Form:C1466.products.length>=1)
		Form:C1466.selectedProduct:=Form:C1466.products.first()
		
		OBJECT SET ENABLED:C1123(*; "ToDeleteButton"; Form:C1466.selectedProduct#Null:C1517)
		OBJECT SET ENABLED:C1123(*; "DropButton"; Form:C1466.selectedProduct#Null:C1517)
	Else 
		OBJECT SET ENABLED:C1123(*; "ToDeleteButton"; False:C215)
		OBJECT SET ENABLED:C1123(*; "DropButton"; False:C215)
	End if 
	
End if 

OBJECT SET VISIBLE:C603(*; "Message2"; True:C214)
OBJECT SET VISIBLE:C603(*; "Info2"; True:C214)










