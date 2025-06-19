Class extends DataStoreImplementation

exposed Function generateData()
	dropDB()
	initDB()
	webform.setMessage("Data generated!")
	
exposed Function getManifestObject() : Object
	var $manifestFile : 4D:C1709.File
	var $manifestObject : Object
	$manifestFile:=File:C1566("/PACKAGE/Project/Sources/Shared/manifest.json")
	$manifestObject:=JSON Parse:C1218($manifestFile.getText())
	return $manifestObject
	
exposed Function authentify($email : Text; $pwd : Text) : cs:C1710.UserEntity
	var $user : cs:C1710.UserEntity
	If (($email#"") && ($pwd#""))
		$user:=ds:C1482.User.query("email = :1"; $email).first()
		If ($user#Null:C1517)
			If (Verify password hash:C1534($pwd; $user.password))
				Use (Session:C1714.storage)
					Session:C1714.storage.playload:=New shared object:C1526("ID"; $user.ID; "email"; $user.email; "role"; $user.role)
				End use 
				Session:C1714.setPrivileges($user.role)
				Web Form:C1735.Dlg.hide()
				return $user
			Else 
				Web Form:C1735.setWarning("The username or password is incorrect. Please try again or Forgot Email/Password?")
			End if 
		Else 
			Web Form:C1735.setWarning("The username or password is incorrect. Please try again or Forgot Email/Password?")
		End if 
	Else 
		Web Form:C1735.setWarning("Please fill all required fields")
	End if 
	
exposed Function logout()
	Session:C1714.clearPrivileges()
	Use (Session:C1714.storage)
		Session:C1714.storage.playload:=New shared object:C1526()
	End use 
	
exposed Function onLoad()->$user : cs:C1710.UserEntity
	var $currentUser : Object
	var $success : Boolean
	If ((Session:C1714.storage.playload#Null:C1517) && (Session:C1714.storage.playload.ID#Null:C1517))
		$user:=ds:C1482.User.get(Session:C1714.storage.playload.ID)
	End if 
	
exposed Function resetPassword($email : Text)
	var $user : cs:C1710.UserEntity
	var $mail : cs:C1710.Mailer
	var $password; $url : Text
	var $info : Object
	var $sendMail : Boolean
	var $html : Text
	var $emailObj : Object:={personalizations: []}
	$url:=""
	If ($email="")
		Web Form:C1735.setWarning("Please Enter Your Email !!")
	Else 
		$user:=ds:C1482.User.query("email = :1"; $email).first()
		If ($user#Null:C1517)
			$password:=generatePassword()
			$user.password:=Generate password hash:C1533($password)
			$info:=$user.save()
			If ($info.success)
				$emailObj.personalizations:=[{to: [{$email: $email}]}]
				$emailObj.subject:="Your KnowBase password reset request"
				$html:="<!doctype html>"+\
					"<html lang=\"en-US\">"+\
					"<head>"+\
					"<meta content=\"text/$html; charset=utf-8\" http-equiv=\"Content-Type\" />"+\
					"<title>KnowBase password has been changed</title>"+\
					"<meta name=\"description\" content=\"Your KnowBase account is successfully created.\">"+\
					"<style type=\"text/css\">"+\
					"a:hover {text-decoration: underline !important;}"+\
					"</style>"+\
					"</head>"+\
					"<body style=\"margin: 0; background-color: #f2f3f8; font-family: 'Open Sans', sans-serif;\">"+\
					"<table width=\"100%\" bgcolor=\"#f2f3f8\" style=\"margin: 0 auto; font-family: 'Open Sans', sans-serif;\">"+\
					"<tr>"+\
					"<td>"+\
					"<table width=\"100%\" bgcolor=\"#f2f3f8\" style=\"margin: 0 auto; max-width: 670px;\">"+\
					"<tr>"+\
					"<td style=\"text-align: center; padding: 40px;\">"+\
					"<a href=\"https://qodly.com\" target=\"_blank\">"+\
					"<img src=\"https://qodly.com/themes/custom/qodly/logo.svg\" width=\"200\" alt=\"Qodly Logo\" />"+\
					"</a>"+\
					"</td>"+\
					"</tr>"+\
					"<tr>"+\
					"<td style=\"background: #fff; border-radius: 3px; text-align: center; box-shadow: 0 6px 18px rgba(0; 0; 0; 0.06); padding: 35px;\">"+\
					"<h1 style=\"font-size: 24px; color: #1e1e2d; font-weight: 500;\">Admin sent you a temporary password</h1>"+\
					"<p style=\"font-size: 15px; color: #455056; line-height: 24px;\">"+\
					"We cannot send you your password directly. Instead, a unique password has been generated for your account to complete your setup: "+\
					"<br/><strong style=\"color: #3976D0; font-size: 16px;\">"+$password+"</strong>"+\
					"<br/><br/>"+\
					"To complete your account setup, click the following link and sign in with the given password."+\
					"</p>"+\
					"<a href=\""+$url+"\" "+\
					"style=\"background: #3976D0; color: #fff; text-decoration: none; font-size: 14px; padding: 10px 24px; border-radius: 50px; display: inline-block;\">"+\
					"Sign In"+\
					"</a>"+\
					"</td>"+\
					"</tr>"+\
					"<tr>"+\
					"<td style=\"text-align: center; padding: 20px; font-size: 14px; color: rgba(69; 80; 86; 0.74);\">"+\
					"&copy; <strong>www.qodly.com</strong>"+\
					"</td>"+\
					" </tr>"+\
					"</table>"+\
					"</td>"+\
					"</tr>"+\
					"</table>"+\
					"</body>"+\
					"</html>"
				$emailObj.content:=[{type: "text/html"; value: $html}]
				cs:C1710.Mailer.me.send($emailObj)
				Web Form:C1735.setMessage("If the email address you provided exists in our system, you will receive an email with instructions to reset your password. Please check your inbox (and spam folder) shortly.")
			End if 
		Else 
			Web Form:C1735.setWarning("Incorrect Email !Please sign up")
		End if 
	End if 
	
exposed Function register($email : Text; $lastname : Text; $firstname : Text; $password : Text; $repassword : Text)
	var $user : cs:C1710.UserEntity
	var $pattern_t : Text:="\\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}\\b"
	var $info : Object
	var $html; $url : Text
	var $mail : Object:={personalizations: []}
	// TODO: test it
	If (($email="") || ($password="") || ($repassword="") || ($lastname="") || ($firstname=""))
		Web Form:C1735.setWarning("Please fill all required fields")
	Else 
		Case of 
			: (Not:C34(Match regex:C1019($pattern_t; $email; 1)))
				Web Form:C1735.setWarning("Invalid email format ")
			: ($password#$repassword)
				Web Form:C1735.setWarning("Passwords don't match")
			Else 
				$user:=ds:C1482.User.query("email = :1"; $email).first()
				If ($user#Null:C1517)
					Web Form:C1735.setWarning("Email already exists")
				Else 
					$user:=ds:C1482.User.new()
					$user.firstname:=$firstname
					$user.lastname:=$lastname
					$user.email:=$email
					$user.password:=Generate password hash:C1533($password)
					$user.role:="Learner"
					$user.active:=True:C214
					$user.creationDate:=Current date:C33
					$user.commentMail:=True:C214
					$user.commentNotification:=True:C214
					$user.likeMail:=True:C214
					$user.likeNotification:=True:C214
					$info:=$user.save()
					If ($info.success)
						
						$mail.personalizations:=[{to: [{$email: $email}]}]
						$mail.subject:="Your KnowBase account is created"
						$url:=""
						$html:="<!doctype html>"+\
							"<html lang=\"en-US\">"+\
							"<head>"+\
							"<meta content=\"text/$html; charset=utf-8\" http-equiv=\"Content-Type\" />"+\
							"<title>KnowBase Account Created</title>"+\
							"<meta name=\"description\" content=\"Your KnowBase account is successfully created.\">"+\
							"<style type=\"text/css\">"+\
							"a:hover {text-decoration: underline !important;}"+\
							"</style>"+\
							"</head>"+\
							"<body style=\"margin: 0; background-color: #f2f3f8; font-family: 'Open Sans', sans-serif;\">"+\
							"<table width=\"100%\" bgcolor=\"#f2f3f8\" style=\"margin: 0 auto; font-family: 'Open Sans', sans-serif;\">"+\
							"<tr>"+\
							"<td>"+\
							"<table width=\"100%\" bgcolor=\"#f2f3f8\" style=\"margin: 0 auto; max-width: 670px;\">"+\
							"<tr>"+\
							"<td style=\"text-align: center; padding: 40px;\">"+\
							"<a href=\"https://qodly.com\" target=\"_blank\">"+\
							"<img src=\"https://qodly.com/themes/custom/qodly/logo.svg\" width=\"200\" alt=\"Qodly Logo\" />"+\
							"</a>"+\
							"</td>"+\
							"</tr>"+\
							"<tr>"+\
							"<td style=\"background: #fff; border-radius: 3px; text-align: center; box-shadow: 0 6px 18px rgba(0; 0; 0; 0.06); padding: 35px;\">"+\
							"<h1 style=\"font-size: 24px; color: #1e1e2d; font-weight: 500;\">Your KnowBase account has been created</h1>"+\
							"<p style=\"font-size: 15px; color: #455056; line-height: 24px;\">"+\
							"Welcome to KnowBase! Your account has been successfully created. To get started, simply click the link below to log in and begin exploring all the features available to you."+\
							"</p>"+\
							"<a href=\""+$url+"\" "+\
							"style=\"background: #3976D0; color: #fff; text-decoration: none; font-size: 14px; padding: 10px 24px; border-radius: 50px; display: inline-block;\">"+\
							"Log In"+\
							"</a>"+\
							"</td>"+\
							"</tr>"+\
							"<tr>"+\
							"<td style=\"text-align: center; padding: 20px; font-size: 14px; color: rgba(69; 80; 86; 0.74);\">"+\
							"&copy; <strong>www.qodly.com</strong>"+\
							"</td>"+\
							" </tr>"+\
							"</table>"+\
							"</td>"+\
							"</tr>"+\
							"</table>"+\
							"</body>"+\
							"</html>"
						$mail.content:=[{type: "text/html"; value: $html}]
						cs:C1710.Mailer.me.send($mail)
						Web Form:C1735.setMessage("Email sent successfuly!")
					Else 
						Web Form:C1735.setWarning("An error occurred while creating the account.")
					End if 
				End if 
		End case 
	End if 
	