Class extends DataClass

exposed function search($name : text)->$result : cs.UserSelection
	$result := this.query("fullName = :1 or email = :1"; "@"+$name+"@").orderBy("firstname asc, lastname asc")
	
exposed function create($email : text; $firstname : text; $lastname : text; $role : text)->$result : boolean
	var $user: cs.UserEntity
	var $pattern_t; password; html; url: text
	var $mail: object := {}
	var $mailingResult: boolean  //added now
	$pattern_t := "\\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}\\b"
	
	if (($email = "") || ($firstname = "") || ($lastname = ""))
		web Form.setWarning("Please Fill all fields !!")
	else 
		$user := this.query("email = :1"; $email).first()
		if ($user # null)
			web Form.setWarning("Email Already exists please Sign in or Forget your password")
		else 
			case of 
				: (not(Match regex($pattern_t; $email; 1)))
					web Form.setWarning("Email Format is incorrect")
				: (Match regex($pattern_t; $email; 1))
					password := generatePassword()
					$user := ds.User.new()
					$user.email := $email
					$user.lastname := $lastname
					$user.firstname := $firstname
					$user.role := $role
					$user.password := Generate password hash(password)
					$user.active := true
					$user.commentMail := true
					$user.commentNotification := true
					$user.likeMail := true
					$user.likeNotification := true
					$user.save()
					$mail.personalizations := [{to: [{$email: $email}]}]
					$mail.subject := "Your KnowBase account is created"
					url := ""
					html := "<!doctype html>"+\
						"<html lang=\"en-US\">"+\
						"<head>"+\
						"<meta content=\"text/html; charset=utf-8\" http-equiv=\"Content-Type\" />"+\
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
						"<h1 style=\"font-size: 24px; color: #1e1e2d; font-weight: 500;\">Your KnowBase account is created</h1>"+\
						"<p style=\"font-size: 15px; color: #455056; line-height: 24px;\">"+\
						"Your KnowBase account has been successfully created. To access your account, use the following password:"+\
						"<br/><strong style=\"color: #3976D0; font-size: 16px;\">"+password+"</strong>"+\
						"<br/><br/>"+\
						"Click the button below to sign in with your new account:"+\
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
					$mail.content := [{type: "text/html"; value: html}]
					$mailingResult := cs.Mailer.me.send($mail)//added the =
					web Form.addUser.hide()
					if ($mailingResult)
						web Form.setMessage("Email sent successfuly!!")
					end if 
			end case 
		end if 
	end if 
	
exposed function userPieChart() : collection
	var $stats: collection := []
	var $users: cs.UserSelection := this.all()
	$stats.push({label: "active"; value: $users.query("active = :1"; true).length})
	$stats.push({label: "inactive"; value: $users.query("active = :1"; false).length})
	return $stats
	
exposed function topUsers($role : text) : collection
	var $stats: collection := []
	var $values: collection
	var $users: cs.UserSelection
	case of 
		: ($role = "")
			$users := this.all().orderByFormula("this.articles.length"; ck descending).slice(0; 20)
		: (($role = "Admin") || ($role = "Tutor"))
			$users := this.query("role = :1"; $role).orderByFormula("this.articles.length"; ck descending).slice(0; 20)
		: ($role = "Learner")
			$users := this.query("role = :1"; $role).orderByFormula("this.comments.length"; ck descending).slice(0; 20)
	end case 
	$stats := $users.extract("fullName"; "x"; "articles.length"; "y"; "comments.length"; "z"; "likes.length"; "t")
	
	return $stats