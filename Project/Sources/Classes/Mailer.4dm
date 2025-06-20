shared singleton Class constructor()
	
shared Function send($email : Object)->$result : Boolean
	var $headers : Object
	var $request : 4D:C1709.HTTPRequest
	var $option : Object
	var $sendGrid_token; sendGrid_name : Text
	var $setting : cs:C1710.SettingEntity
	If (Storage:C1525.secrets=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.secrets:=New shared object:C1526()
			
			Use (Storage:C1525.secrets)
				$setting:=ds:C1482.Setting.query("key = :1"; "sendGrid_token").first()
				If ($setting#Null:C1517)
					$sendGrid_token:=$setting.value
					Storage:C1525.secrets.token:=$sendGrid_token
				End if 
				$setting:=ds:C1482.Setting.query("key = :1"; "sendGrid_name").first()
				If ($setting#Null:C1517)
					sendGrid_name:=$setting.value
					Storage:C1525.secrets.name:=sendGrid_name
				End if 
			End use 
		End use 
	End if 
	
	If (Storage:C1525.secrets.name#Null:C1517 && Storage:C1525.secrets.token#Null:C1517)
		$email.from:={$email: Storage:C1525.secrets.name}
		$headers:={}
		$headers["Content-Type"]:="application/json"
		$headers["Authorization"]:=Storage:C1525.secrets.token
		$option:={}
		$option.headers:=$headers
		$option.method:="POST"
		$option.body:=$email
		$request:=4D:C1709.HTTPRequest.new("https://api.sendgrid.com/v3/mail/send"; $option).wait()
		If ($request.response#Null:C1517)
			$result:=($request.response.status=202)
		End if 
	End if 
	