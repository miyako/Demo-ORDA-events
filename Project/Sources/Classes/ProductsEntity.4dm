

Class extends Entity


Class constructor()
	This:C1470.name:="New product"
	This:C1470.costPrice:=100
	This:C1470.retailPrice:=101
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
	// The document path is stored in the guidelines attribute
	// The file name depends on the product name
	//
	This:C1470.guidelinesFile:=Session:C1714.storage.userInfo.docsFolder+"/guidelines_"+This:C1470.name
	
	
	//
	// SAVE EVENTS
	//
	// validateSave event at attribute level
Function event validateSave margin($event : Object) : Object
	
	var $result : Object
	
	//The user can't create a product whose margin is < 50%
	If (This:C1470.margin<Session:C1714.storage.userInfo.marginThreshold)
		$result:={errCode: 1; message: "The validation of this product failed"; \
			extraDescription: {info: "The current margin of this product is "+String:C10(This:C1470.margin)+". You must achieve a "+String:C10(Session:C1714.storage.userInfo.marginThreshold)+" target margin"}; seriousError: False:C215}
	End if 
	
	return $result
	
	
	// saving event at attribute level
Function event saving guidelinesFile($event : Object) : Object
	
	var $result; $docInfo : Object
	var $userManualFile : 4D:C1709.File
	
	
	If (This:C1470.guidelinesFile#"")
		$userManualFile:=File:C1566("/PACKAGE"+This:C1470.guidelinesFile)
		
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
			$result:={errCode: 1; message: "Error during the save action for this product"; extraDescription: {info: "There is no available space on disk to store the guidelines file"}}
		End try
	End if 
	
	return $result
	
	
Function event afterSave($event : Object)
	
	var $docIndexes : Collection
	var $index : Integer
	
	If ($event.status.errors#Null:C1517)
		This:C1470.status:="KO"
	End if 
	
	If (($event.status.success=False:C215) && ($event.status.errors=Null:C1517))  // $event.status.errors is filled if the error comes from the validateSave event
		
		// The guidelines attribute has not been properly saved
		// Its value is reset and the status attribute is set to "KO"
		//
		If ($event.savedAttributes.indexOf("guidelines")=-1)
			This:C1470.guidelinesFile:=""
			This:C1470.status:="Missing guidelines file"
			
			
			cs:C1710.Utilities.me.sendMailAlert(ds:C1482.SalesPeople.get(Session:C1714.storage.userInfo.salesId).adminEmail)
			
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
	
	
	// --------------------------------------------------------------
	//
	// For Qodly
	//
exposed Function saveMe($noSpaceOnDisk : Boolean; $guidelines : Text) : Object
	
	var $status; $docInfo : Object
	var $blob : Blob
	
	
	Use (Storage:C1525.diskInfo)
		Storage:C1525.diskInfo.noSpaceOnDisk:=$noSpaceOnDisk
	End use 
	
	//The content of the user manual file is generated here
	//
	TEXT TO BLOB:C554($guidelines; $blob)
	
	// The content of the user manual file is stored in a map
	//
	
	If (Storage:C1525.docMap.query("name = :1"; This:C1470.name).length#0)
		$docInfo:=Storage:C1525.docMap.query("name = :1"; This:C1470.name).first()
		Use ($docInfo)
			$docInfo.content:=$blob
		End use 
	Else 
		Use (Storage:C1525.docMap)
			Storage:C1525.docMap.push(New shared object:C1526("name"; This:C1470.name; "content"; $blob))
		End use 
	End if 
	
	//This.status:="OK"
	
	Try
		$status:=This:C1470.save()
	Catch
		$status.creationInProgress:=True:C214
		Web Form:C1735.setError($status.errors.first().extraDescription.info)
		return $status
	End try
	
	If ($status.errors#Null:C1517)
		$status.creationInProgress:=True:C214
		Web Form:C1735.setWarning($status.errors.first().extraDescription.info)
	Else 
		$status.creationInProgress:=False:C215
		Web Form:C1735.setMessage("Congratulations! Your product has been created")
	End if 
	
	return $status
	
	
exposed Function apply() : cs:C1710.ProductsEntity
	return This:C1470
	
	