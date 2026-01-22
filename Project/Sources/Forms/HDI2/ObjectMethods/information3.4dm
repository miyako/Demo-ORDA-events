
var $win : Integer


$win:=Open form window:C675("HDI3"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)

SET WINDOW TITLE:C213("Guidelines"; $win)

Form:C1466.guideLines:=GuideLines[0].Description

DIALOG:C40("HDI3"; Form:C1466; *)

CLOSE WINDOW:C154