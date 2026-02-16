Class extends Entity

Class constructor()
	This:C1470.name:="New product"
	This:C1470.costPrice:=100
	This:C1470.retailPrice:=101
	This:C1470.status:="OK"
	This:C1470.createdBy:=ds:C1482.SalesPeople.get(Session:C1714.storage.userInfo.salesId)
	
	
Function event touched name($event : Object)
	This:C1470.guidelinesFile:=Session:C1714.storage.userInfo.docsFolder+"/guidelines_"+This:C1470.name
	
	
Function event validateSave margin($event : Object) : Object
	
	var $result : Object
	
	If (This:C1470.margin<Session:C1714.storage.userInfo.marginThreshold)
		$result:={errCode: 1; message: "You can't create this product"; \
			extraDescription: {info: "The current margin of this product is "+String:C10(This:C1470.margin)+". You must achieve at least a "+String:C10(Session:C1714.storage.userInfo.marginThreshold)+" margin"}; seriousError: False:C215}
	End if 
	
	return $result
	
	
Function event saving guidelinesFile($event : Object) : Object
	
	var $result; $docInfo : Object
	var $userManualFile : 4D:C1709.File
	
	
	If (This:C1470.guidelinesFile#"")
		$userManualFile:=File:C1566("/PACKAGE"+This:C1470.guidelinesFile)
		
		If ($userManualFile.exists)
			$userManualFile.delete()
		End if 
		
		Try
			If (Storage:C1525.diskInfo.noSpaceOnDisk)
				throw:C1805(1; "")
			Else 
				$docInfo:=Storage:C1525.docMap.query("name = :1 and salesId = :2"; This:C1470.name; Session:C1714.storage.userInfo.salesId).first()
				$userManualFile.setContent($docInfo.content)
			End if 
		Catch
			$result:={errCode: 1; message: "Saving the product failed"; extraDescription: {info: "There is no available space on disk to store the guidelines file"}}
		End try
	End if 
	
	return $result
	
	
Function event afterSave($event : Object)
	
	var $docIndexes : Collection
	var $index : Integer
	
	If ($event.status.success=False:C215)
		If ($event.status.errors#Null:C1517)  // $event.status.errors is filled if the error comes from the validateSave event
			This:C1470.status:="KO"
		Else 
			If ($event.savedAttributes.indexOf("guidelinesFile")=-1)
				This:C1470.guidelinesFile:=""
				This:C1470.status:="Missing guidelines file"
				cs:C1710.Utilities.me.sendMailAlert(Session:C1714.storage.userInfo.adminEmail)
			End if 
		End if 
	End if 
	
	$docIndexes:=Storage:C1525.docMap.indices("name = :1 and salesId = :2"; This:C1470.name; Session:C1714.storage.userInfo.salesId)
	
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
	
	If (This:C1470.status#"Missing guidelines file")
		This:C1470.status:="OK"
	End if 
	
	Use (Storage:C1525.diskInfo)
		Storage:C1525.diskInfo.noSpaceOnDisk:=$noSpaceOnDisk
	End use 
	
	//
	//The content of the guidelines file is generated here
	//
	TEXT TO BLOB:C554($guidelines; $blob)
	
	//
	// The content of the guidelines file is stored in a map
	//
	If (Storage:C1525.docMap.query("name = :1"; This:C1470.name).length#0)
		$docInfo:=Storage:C1525.docMap.query("name = :1 and salesId = :2"; This:C1470.name; Session:C1714.storage.userInfo.salesId).first()
		Use ($docInfo)
			$docInfo.content:=$blob
		End use 
	Else 
		Use (Storage:C1525.docMap)
			Storage:C1525.docMap.push(New shared object:C1526("name"; This:C1470.name; "salesId"; Session:C1714.storage.userInfo.salesId; "content"; $blob))
		End use 
	End if 
	
	Try
		$status:=This:C1470.save()
	Catch
		$status.creationInProgress:=True:C214
		Web Form:C1735.setError($status.errors.first().message+".    "+$status.errors.first().extraDescription.info)
		return $status
	End try
	
	If ($status.success=False:C215)
		$status.creationInProgress:=True:C214
		Web Form:C1735.setWarning($status.errors.first().message+".      "+$status.errors.first().extraDescription.info)
		
	Else 
		$status.creationInProgress:=False:C215
		Web Form:C1735.setMessage("Congratulations! Your product has been created")
	End if 
	
	return $status
	
exposed Function apply() : cs:C1710.ProductsEntity
	return This:C1470
	
	
	//
	// Computed attribute
	//
exposed Function get guideLinesShortPath() : Text
	
	If (Session:C1714.storage.userInfo#Null:C1517)
		return Replace string:C233(This:C1470.guidelinesFile; Session:C1714.storage.userInfo.docsFolder; "")
	Else 
		return "Not applicable"
	End if 
	
	//
	// Computed attribute
	//
exposed Function get margin() : Real
	return ((This:C1470.retailPrice-This:C1470.costPrice)*100)/This:C1470.costPrice