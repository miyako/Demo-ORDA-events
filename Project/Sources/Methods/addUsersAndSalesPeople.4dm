//%attributes = {}


var $user : cs:C1710.UsersEntity
var $sale : cs:C1710.SalesPeopleEntity
var $status : Object
var $notDropped : 4D:C1709.EntitySelection
var $femalePhotoFiles; $malePhotoFiles : Collection
var $myFile : 4D:C1709.File
var $myPhoto : Picture


$femalePhotoFiles:=Folder:C1567("/RESOURCES/femalefaces/").files()
$malePhotoFiles:=Folder:C1567("/RESOURCES/malefaces/").files()

$sale:=ds:C1482.SalesPeople.get(1)
$myFile:=$femalePhotoFiles[0]
READ PICTURE FILE:C678($myFile.platformPath; $myPhoto)

$sale.photo:=$myPhoto
$status:=$sale.save()


$sale:=ds:C1482.SalesPeople.get(2)
$myFile:=$malePhotoFiles[0]
READ PICTURE FILE:C678($myFile.platformPath; $myPhoto)

$sale.photo:=$myPhoto
$status:=$sale.save()


//$user:=ds.Users.new()
//$user.identifier:="mary@4d.com"
//$user.password:=Generate password hash("a")
//$status:=$user.save()

//$sale:=ds.SalesPeople.new()
//$sale.user:=$user
//$sale.firstname:="Mary"
//$sale.lastname:="Smith"

//$myFile:=$femalePhotoFiles[0]
//READ PICTURE FILE($myFile.platformPath; $myPhoto)

//$sale.photo:=$myPhoto
//$status:=$sale.save()


//$user:=ds.Users.new()
//$user.identifier:="arthur@4d.com"
//$user.password:=Generate password hash("a")
//$status:=$user.save()

//$sale:=ds.SalesPeople.new()
//$sale.user:=$user
//$sale.firstname:="Arthur"
//$sale.lastname:="Brown"

//$myFile:=$malePhotoFiles[0]
//READ PICTURE FILE($myFile.platformPath; $myPhoto)

//$sale.photo:=$myPhoto
//$status:=$sale.save()




////For each ($order; ds.Orders.all().slice(0; 6))
////$order.user:=$user
////$status:=$order.save()
////End for each 


