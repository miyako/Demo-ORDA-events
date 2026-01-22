

Class extends Entity


Class constructor()
	This:C1470.name:="New product"
	This:C1470.costPrice:=100
	This:C1470.retailPrice:=110
	This:C1470.status:="OK"
	
	//
	// Computed attribute
	//
exposed Function get margin() : Real
	return ((This:C1470.retailPrice-This:C1470.costPrice)*100)/This:C1470.costPrice
	
	//
	// Touched event
	//
Function event touched name($event : Object)
	
	// The user manual document file will be stored on disk if the product is saved
	// The document path is stored in the userManualPath attribute
	// The file name depends on the product name
	//
	This:C1470.userManualPath:="/PACKAGE/Resources/Files"+/userManual_"+This.name"
	
	
	//
	// SAVE EVENTS
	//
	// validateSave event at attribute level
Function event validateSave margin($event : Object) : Object
	
	var $result : Object
	
	//The user can't create a product whose margin is < 50%
	If (This:C1470.margin<50)
		$result:={errCode: 1; message: "The validation of this product failed"; \
			extraDescription: {info: "The margin of this product ("+String:C10(This:C1470.margin)+") is lower than 50%"}; seriousError: False:C215}
	End if 
	
	return $result
	
	
	// saving event at attribute level
Function event saving userManualPath($event : Object) : Object
	
	var $result; $docInfo : Object
	var $userManualFile : 4D:C1709.File
	
	
	If (This:C1470.userManualPath#"")
		$userManualFile:=File:C1566(This:C1470.userManualPath)
		
		If ($userManualFile.exists)
			$userManualFile.delete()
		End if 
		
		// The user manual document file is created on the disk
		// This may fail if there is not enough space available on disk
		//
		Try
			If (Storage:C1525.diskInfo.noSpaceOnDisk)
				throw:C1805(1; "")
			Else 
				
				// The content of the file has been generated
				// and stored in a map (Storage.docMap) previously
				// It is done outside the save action
				// because generating the content can take time
				//
				$docInfo:=Storage:C1525.docMap.query("name = :1"; This:C1470.name).first()
				
				// The content of the file is filled
				$userManualFile.setContent($docInfo.content)
				
			End if 
		Catch
			// E.g.: No more space on disk
			$result:={errCode: 1; message: "Error during the save action for this product"; extraDescription: {info: "There is no available space on disk to store the user manual"}}
		End try
	End if 
	
	return $result
	
	
Function event afterSave($event : Object)
	
	var $docIndexes : Collection
	var $index : Integer
	
	If (($event.status.success=False:C215) && ($event.status.errors=Null:C1517))  // $event.status.errors is filled if the error comes from the validateSave event
		
		// The userManualPath attribute has not been properly saved
		// Its value is reset and the status attribute is set to "KO"
		//
		If ($event.savedAttributes.indexOf("userManualPath")=-1)
			This:C1470.userManualPath:=""
			This:C1470.status:="KO"
		End if 
		
	End if 
	
	// Wether the save action is successful or not
	// The user manual content is removed from the map
	//
	$docIndexes:=Storage:C1525.docMap.indices("name = :1"; This:C1470.name)
	
	If ($docIndexes.length>=0)
		Use (Storage:C1525.docMap)
			For each ($index; $docIndexes)
				Storage:C1525.docMap.remove($index)
			End for each 
		End use 
	End if 
	
	// ------------------------------------------------
	//
	// DROP EVENTS
	//
	// validateDrop event at attribute level
Function event validateDrop status($event : Object) : Object
	
	var $result : Object
	
	// Products must be marked as TO DELETE to be dropped
	//
	If (This:C1470.status#"TO DELETE")
		$result:={errCode: 1; message: "You can't drop this product"; \
			extraDescription: {info: "This product must be marked as To Delete"}; seriousError: False:C215}
	End if 
	
	return $result
	
	
	// dropping event at entity level
Function event dropping($event : Object) : Object
	
	var $result : Object
	var $userManualFile : 4D:C1709.File
	
	
	$userManualFile:=File:C1566(This:C1470.userManualPath)
	
	// When dropping a product, its user manual document is also deleted on the disk
	// This action may fail
	//
	Try
		If (Storage:C1525.diskInfo.errorOnDropFile)
			throw:C1805(1; "")
		Else 
			If ($userManualFile.exists)
				$userManualFile.delete()
			End if 
		End if 
	Catch
		// Dropping the user manual document failed
		$result:={errCode: 1; message: "Drop failed"; extraDescription: {info: "The user manual can't be dropped"}}
	End try
	
	return $result
	
	
	
Function event afterDrop($event : Object)
	
	var $status : Object
	
	// The drop action failed - The product must be checked manually
	//
	If (($event.status.success=False:C215) && ($event.status.errors=Null:C1517))  // $event.status.errors is filled if the error comes from the validateDrop event
		This:C1470.status:="Drop action failed"
		$status:=This:C1470.save()
	End if 
	
	// --------------------------------------------------------------
	//
	// For Qodly
	//
exposed Function saveMe($noSpaceOnDisk : Boolean) : Object
	
	var $status : Object
	var $blob : Blob
	
	
	Use (Storage:C1525.diskInfo)
		Storage:C1525.diskInfo.noSpaceOnDisk:=$noSpaceOnDisk
	End use 
	
	
	//The content of the user manual file is generated here
	//
	TEXT TO BLOB:C554("This is the "+This:C1470.name+" user manual"; $blob)
	
	
	// The content of the user manual file is stored in a map
	//
	Use (Storage:C1525.docMap)
		Storage:C1525.docMap.push(New shared object:C1526("name"; This:C1470.name; "content"; $blob))
	End use 
	
	Try
		$status:=This:C1470.save()
	Catch
		Web Form:C1735.setError($status.errors.first().message+" - "+$status.errors.first().extraDescription.info)
		return $status
	End try
	
	If ($status.errors#Null:C1517)
		Web Form:C1735.setWarning($status.errors.first().message+" - "+$status.errors.first().extraDescription.info)
	Else 
		Web Form:C1735.setMessage("Congratulations! Your product has been created")
	End if 
	
	return $status
	
	
exposed Function dropMe($errorOnDropFile : Boolean) : Object
	
	var $status : Object
	
	Use (Storage:C1525.diskInfo)
		Storage:C1525.diskInfo.errorOnDropFile:=$errorOnDropFile
	End use 
	
	Try
		$status:=This:C1470.drop()
	Catch
		Web Form:C1735.setError($status.errors.first().message+" - "+$status.errors.first().extraDescription.info)
		return $status
	End try
	
	If ($status.errors#Null:C1517)
		Web Form:C1735.setWarning($status.errors.first().message+" - "+$status.errors.first().extraDescription.info)
	Else 
		Web Form:C1735.setMessage("Congratulations! Your product has been dropped")
	End if 
	
	return $status
	
exposed Function markAsDelete()
	
	var $status : Object
	
	This:C1470.status:="TO DELETE"
	
	$status:=This:C1470.save()
	
	Web Form:C1735.setMessage("You can now drop this product")
	
	
exposed Function apply() : cs:C1710.ProductsEntity
	return This:C1470
	
	
	