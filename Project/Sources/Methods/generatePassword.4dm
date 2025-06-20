//%attributes = {}
#DECLARE()->$result : Text
var $password; $Vuppercase; $Vlowercase; $digits; $symbols; $Vchar : Text
var $Vlength; $Vrandom; $i : Integer

$Vuppercase:="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
$Vlowercase:="abcdefghijklmnopqrstuvwxyz"
$digits:="0123456789"
$symbols:="!#$%&()*+,-./:;<=>?@[\\]^_`{|}~"

$Vlength:=12
$password:=""
For (i; 1; $Vlength)
	$Vrandom:=(Random:C100%(4))
	Case of 
		: ($Vrandom=0)
			$Vchar:=Substring:C12($Vuppercase; (Random:C100%(Length:C16($Vuppercase)))+1; 1)
		: ($Vrandom=1)
			$Vchar:=Substring:C12($Vlowercase; (Random:C100%(Length:C16($Vlowercase)))+1; 1)
		: ($Vrandom=2)
			$Vchar:=Substring:C12($digits; (Random:C100%(Length:C16($digits)))+1; 1)
		: ($Vrandom=3)
			$Vchar:=Substring:C12($symbols; (Random:C100%(Length:C16($symbols)))+1; 1)
	End case 
	$password:=$password+$Vchar
End for 
$result:=$password
