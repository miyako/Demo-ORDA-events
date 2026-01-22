Class extends Entity


exposed Function get fullname($event : Object)->$result : Text
	If (This:C1470.firstname=Null:C1517)
		$result:=This:C1470.lastname
	Else 
		If (This:C1470.lastname=Null:C1517)
			$result:=This:C1470.firstname
		Else 
			$result:=This:C1470.firstname+" "+This:C1470.lastname
		End if 
	End if 
	
	
	