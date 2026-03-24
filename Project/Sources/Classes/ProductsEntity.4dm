Class extends Entity

Class constructor()
/*
新規レコードの初期値を設定
*/
	This:C1470.name:="新しい商品"
	This:C1470.costPrice:=100
	This:C1470.retailPrice:=101
	This:C1470.status:="OK"
	This:C1470.createdBy:=ds:C1482.SalesPeople.get(Session:C1714.storage.userInfo.salesId)
	
Function event touched name($event : Object)
/*
nameフィールドに値が代入されるたびに実行されるイベント
*/
	This:C1470.guidelinesFile:=Session:C1714.storage.userInfo.docsFolder+"/guidelines_"+This:C1470.name
	
Function event validateSave margin($event : Object) : Object
/*
レコードの保存前に実行されるイベント
*/
	var $result : Object
	
	If (This:C1470.margin<Session:C1714.storage.userInfo.marginThreshold)
		$result:={errCode: 1; message: "商品を登録できません。"; \
			extraDescription: {info: \
			"マージン"+String:C10(This:C1470.margin)+"が不十分です。"+\
			"最低マージンは"+String:C10(Session:C1714.storage.userInfo.marginThreshold)+"です。"\
			}; seriousError: False:C215}
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
			$result:={errCode: 1; \
				message: "商品を保存できません"; \
				extraDescription: {\
				info: "ディスクに十分な空きスペースがありません"}}
		End try
	End if 
	
	return $result
	
Function event afterSave($event : Object)
	
	var $docIndexes : Collection
	var $index : Integer
	
	If ($event.status.success=False:C215)
		If ($event.status.errors#Null:C1517)
			This:C1470.status:="KO"
		Else 
			If ($event.savedAttributes.indexOf("guidelinesFile")=-1)
				This:C1470.guidelinesFile:=""
				This:C1470.status:="資料が登録されていません!"
				cs:C1710.Utilities.me.sendMailAlert(Session:C1714.storage.userInfo.adminEmail)
			End if 
		End if 
	End if 
	
	$docIndexes:=Storage:C1525.docMap.indices("name = :1 and salesId = :2"; This:C1470.name; Session:C1714.storage.userInfo.salesId)
	
	If ($docIndexes.length>=1)
		Use (Storage:C1525.docMap)
			For each ($index; $docIndexes)
				Storage:C1525.docMap.remove($index)
			End for each 
		End use 
	End if 
	
/*
exposed: Qodlyで使用するメンバー関数
*/
	
exposed Function saveMe($noSpaceOnDisk : Boolean; $guidelines : Text) : Object
	
	var $status; $docInfo : Object
	var $blob : Blob
	var $docs : Collection
	
	If (This:C1470.status#"資料が登録されていません!")
		This:C1470.status:="OK"
	End if 
	
	Use (Storage:C1525.diskInfo)
		Storage:C1525.diskInfo.noSpaceOnDisk:=$noSpaceOnDisk
	End use 
	
	If ($guidelines#"")
		TEXT TO BLOB:C554($guidelines; $blob)
		$docs:=Storage:C1525.docMap.query("name = :1 and salesId = :2"; This:C1470.name; Session:C1714.storage.userInfo.salesId)
		If ($docs.length#0)
			$docInfo:=$docs.first()
			Use ($docInfo)
				$docInfo.content:=$blob
			End use 
		Else 
			Use (Storage:C1525.docMap)
				Storage:C1525.docMap.push(New shared object:C1526("name"; This:C1470.name; "salesId"; Session:C1714.storage.userInfo.salesId; "content"; $blob))
			End use 
		End if 
	End if 
	
	Try
		$status:=This:C1470.save()
	Catch
		$status.creationInProgress:=True:C214
		Web Form:C1735.setError($status.errors.first().message+"。"+$status.errors.first().extraDescription.info)
		return $status
	End try
	
	If ($status.success=False:C215)
		$status.creationInProgress:=True:C214
		Web Form:C1735.setWarning($status.errors.first().message+"。"+$status.errors.first().extraDescription.info)
	Else 
		$status.creationInProgress:=False:C215
		Web Form:C1735.setMessage("商品が登録されました!")
	End if 
	
	return $status
	
exposed Function apply() : cs:C1710.ProductsEntity
	
	return This:C1470
	
exposed Function get guideLinesShortPath() : Text
	
	If (Session:C1714.storage.userInfo#Null:C1517)
		return Replace string:C233(This:C1470.guidelinesFile; Session:C1714.storage.userInfo.docsFolder; "")
	Else 
		return "ログインが必要です。"
	End if 
	
exposed Function get margin() : Real
	
	return ((This:C1470.retailPrice-This:C1470.costPrice)*100)/This:C1470.costPrice