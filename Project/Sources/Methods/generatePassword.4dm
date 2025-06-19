//%attributes = {}
declare()->$result : text
var $password; Vuppercase; Vlowercase; digits; symbols; Vchar: text
var $Vlength; Vrandom; i: integer

Vuppercase := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
Vlowercase := "abcdefghijklmnopqrstuvwxyz"
digits := "0123456789"
symbols := "!#$%&()*+,-./:;<=>?@[\\]^_`{|}~"

$Vlength := 12
$password := ""
for (i; 1; $Vlength)
	Vrandom := (random%(4))
	case of 
		: (Vrandom = 0)
			Vchar := substring(Vuppercase, (random%(length(Vuppercase)))+1, 1)
		: (Vrandom = 1)
			Vchar := substring(Vlowercase, (random%(length(Vlowercase)))+1, 1)
		: (Vrandom = 2)
			Vchar := substring(digits, (random%(length(digits)))+1, 1)
		: (Vrandom = 3)
			Vchar := substring(symbols, (random%(length(symbols)))+1, 1)
	end case 
	$password := $password+Vchar
end for 
$result := $password
