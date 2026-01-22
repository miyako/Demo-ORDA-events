
var $blob : Blob



If (btnTrace)
	TRACE:C157
End if 

//The content of the user manual file is generated here
//
TEXT TO BLOB:C554("This is the "+Form:C1466.product.name+" user manual"; $blob)


// The content of the user manual file is stored in a map
//
Use (Storage:C1525.docMap)
	Storage:C1525.docMap.push(New shared object:C1526("name"; Form:C1466.product.name; "content"; $blob))
End use 


Try
	Form:C1466.status:=Form:C1466.product.save()
Catch
	// Serious error
	OBJECT SET RGB COLORS:C628(*; "Message"; "#ff0000")
	OBJECT SET RGB COLORS:C628(*; "Info"; "#ff0000")
	
	OBJECT SET RGB COLORS:C628(*; "MarginValue"; "#000000")
	
	OBJECT SET RGB COLORS:C628(*; "UserManualValue"; "#ff0000")
	
	OBJECT SET RGB COLORS:C628(*; "StatusValue"; "#ff0000")
	
	OBJECT SET VISIBLE:C603(*; "SaveButton"; False:C215)
	
End try

If (Form:C1466.status.errors#Null:C1517)
	Form:C1466.info:=Form:C1466.status.errors.first().extraDescription.info
	Form:C1466.message:=Form:C1466.status.errors.first().message
	
	If (Form:C1466.status.errors.first().seriousError=False:C215)
		OBJECT SET RGB COLORS:C628(*; "Message"; "#ff9933")
		OBJECT SET RGB COLORS:C628(*; "Info"; "#ff9933")
		OBJECT SET RGB COLORS:C628(*; "MarginValue"; "#ff9933")
	End if 
	
Else 
	Form:C1466.message:="The product has been created"
	Form:C1466.info:="Congratulations"
	
	OBJECT SET RGB COLORS:C628(*; "Message"; "#009933")
	OBJECT SET RGB COLORS:C628(*; "Info"; "#009933")
	
	OBJECT SET RGB COLORS:C628(*; "MarginValue"; "#008000")
	OBJECT SET RGB COLORS:C628(*; "UserManualValue"; "#008000")
	OBJECT SET RGB COLORS:C628(*; "StatusValue"; "#008000")
	
	OBJECT SET VISIBLE:C603(*; "SaveButton"; False:C215)
	//
End if 


OBJECT SET VISIBLE:C603(*; "Message"; True:C214)
OBJECT SET VISIBLE:C603(*; "Info"; True:C214)

Form:C1466.products:=ds:C1482.Products.all()






