Class extends DataStoreImplementation

exposed function generateData()
	dropDB()
	initDB()
	webform.setMessage("Data generated!")
	
exposed function getManifestObject() : object
	var $manifestFile: 4D.File
	var $manifestObject: object
	$manifestFile := file("/PACKAGE/Project/Sources/Shared/manifest.json")
	$manifestObject := JSON Parse($manifestFile.getText())
	return $manifestObject
	
exposed function authentify($email : text; $pwd : text) : cs.UserEntity
	var $user: cs.UserEntity
	if ($email # "" && $pwd # "")
		$user := ds.User.query("email = :1"; $email).first()
		if ($user # null)
			if (Verify password hash($pwd; $user.password))
				use (session.storage)
					session.storage.playload := new Shared Object("ID"; $user.ID; "email"; $user.email; "role"; $user.role)
				end use 
				session.setPrivileges($user.role)
				web Form.Dlg.hide()
				return $user
			else 
				web Form.setWarning("The username or password is incorrect. Please try again or Forgot Email/Password?")
			end if 
		else 
			web Form.setWarning("The username or password is incorrect. Please try again or Forgot Email/Password?")
		end if 
	else 
		web Form.setWarning("Please fill all required fields")
	end if 
	
exposed function logout()
	session.clearPrivileges()
	use (session.storage)
		session.storage.playload := new Shared Object()
	end use 
	
exposed function onLoad()->$user : cs.UserEntity
	var $currentUser: object
	var $usersInterface: cs.Qodly.Users
	var $success: boolean
	case of 
		: ((session.storage.playload # null) && (session.storage.playload.ID # null))
			$user := ds.User.get(session.storage.playload.ID)
		: ((session.userName # null) && (session.userName # ""))
			$usersInterface := cs.Qodly.Users.new()
			$currentUser := $usersInterface.getCurrentUser()
			if ($currentUser.email # null)
				$user := ds.User.query("email = :1"; $currentUser.email).first()
				if ($user = null)
					$success := ds.User.create($currentUser.email; $currentUser.firstname; $currentUser.lastname; $currentUser.role)
					if ($success)
						$user := ds.User.query("email = :1"; $currentUser.email).first()
					end if 
				end if 
				
				if ($user # null)
					use (session.storage)
						session.storage.playload := new Shared Object("ID"; $user.ID; "email"; $user.email; "role"; $user.role)
					end use 
					session.setPrivileges($user.role)
				end if 
			end if 
			
	end case 
	
exposed function resetPassword($email : text)
	var $user: cs.UserEntity
	var $mail: cs.Mailer
	var $password; url: text
	var $info: object
	var $sendMail: boolean
	var $html: text
	var $emailObj: object := {personalizations: []}
	url := ""
	if ($email = "")
		web Form.setWarning("Please Enter Your Email !!")
	else 
		$user := ds.User.query("email = :1"; $email).first()
		if ($user # null)
			$password := generatePassword()
			$user.password := Generate password hash($password)
			$info := $user.save()
			if ($info.success)
				$emailObj.personalizations := [{to: [{$email: $email}]}]
				$emailObj.subject := "Your KnowBase password reset request"
				$html := "<!doctype html>"+\
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
					"<a href=\""+url+"\" "+\
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
				$emailObj.content := [{type: "text/html"; value: $html}]
				cs.Mailer.me.send($emailObj)
				web Form.setMessage("If the email address you provided exists in our system, you will receive an email with instructions to reset your password. Please check your inbox (and spam folder) shortly.")
			end if 
		else 
			web Form.setWarning("Incorrect Email !Please sign up")
		end if 
	end if 
	
exposed function register($email : text; $lastname : text; $firstname : text; $password : text; $repassword : text)
	var $user: cs.UserEntity
	var $pattern_t: text := "\\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}\\b"
	var $info: object
	var $html; url: text
	var $mail: object := {personalizations: []}
	// TODO: test it
	if (($email = "") || ($password = "") || ($repassword = "") || ($lastname = "") || ($firstname = ""))
		web Form.setWarning("Please fill all required fields")
	else 
		case of 
			: (not(Match regex($pattern_t; $email; 1)))
				web Form.setWarning("Invalid email format ")
			: ($password # $repassword)
				web Form.setWarning("Passwords don't match")
			else 
				$user := ds.User.query("email = :1"; $email).first()
				if ($user # null)
					web Form.setWarning("Email already exists")
				else 
					$user := ds.User.new()
					$user.firstname := $firstname
					$user.lastname := $lastname
					$user.email := $email
					$user.password := Generate password hash($password)
					$user.role := "Learner"
					$user.active := true
					$user.creationDate := current Date
					$user.commentMail := true
					$user.commentNotification := true
					$user.likeMail := true
					$user.likeNotification := true
					$info := $user.save()
					if ($info.success)
						
						$mail.personalizations := [{to: [{$email: $email}]}]
						$mail.subject := "Your KnowBase account is created"
						url := ""
						$html := "<!doctype html>"+\
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
							"<a href=\""+url+"\" "+\
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
						$mail.content := [{type: "text/html"; value: $html}]
						cs.Mailer.me.send($mail)
						web Form.setMessage("Email sent successfuly!")
					else 
						web Form.setWarning("An error occurred while creating the account.")
					end if 
				end if 
		end case 
	end if 
