shared singleton Class constructor()
	
shared function send($email : object)->$result : boolean
	var $headers: object
	var $request: 4D.HTTPRequest
	var $option: object
	var $sendGrid_token; sendGrid_name: text
	var $setting:cs.SettingEntity
	if (storage.secrets = null)
		use (storage)
			storage.secrets := new Shared Object()
			
			use (storage.secrets)
				$setting := ds.Setting.query("key = :1"; "sendGrid_token").first() 
				if($setting#null)
					$sendGrid_token := $setting.value
					storage.secrets.token := $sendGrid_token
				end if 
				$setting:=ds.Setting.query("key = :1"; "sendGrid_name").first()
				if($setting#null)
					sendGrid_name:=$setting.value
					storage.secrets.name := sendGrid_name
				end if 
			end use 
		end use 
	end if 
	
	if (storage.secrets.name # null && storage.secrets.token # null)
		$email.from := {$email: storage.secrets.name }
		$headers := {}
		$headers["Content-Type"] = "application/json"
		$headers["Authorization"] = storage.secrets.token
		$option := {}
		$option.headers := $headers
		$option.method := "POST"
		$option.body := $email
		$request := 4D.HTTPRequest.new("https://api.sendgrid.com/v3/mail/send"; $option).wait()
		if ($request.response # null)
			$result := ($request.response.status = 202)
		end if 
	end if 
