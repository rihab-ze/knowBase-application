Class extends DataClass

exposed Function search($name : Text)->$result : cs:C1710.UserSelection
	$result:=This:C1470.query("fullName = :1 or email = :1"; "@"+$name+"@").orderBy("firstname asc, lastname asc")
	
exposed Function create($email : Text; $firstname : Text; $lastname : Text; $role : Text)->$result : Boolean
	var $user : cs:C1710.UserEntity
	var $pattern_t; $password; $html; $url : Text
	var $mail : Object:={}
	var $mailingResult : Boolean  //added now
	$pattern_t:="\\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}\\b"
	
	If (($email="") || ($firstname="") || ($lastname=""))
		Web Form:C1735.setWarning("Please Fill all fields !!")
	Else 
		$user:=This:C1470.query("email = :1"; $email).first()
		If ($user#Null:C1517)
			Web Form:C1735.setWarning("Email Already exists please Sign in or Forget your password")
		Else 
			Case of 
				: (Not:C34(Match regex:C1019($pattern_t; $email; 1)))
					Web Form:C1735.setWarning("Email Format is incorrect")
				: (Match regex:C1019($pattern_t; $email; 1))
					$password:=generatePassword()
					$user:=ds:C1482.User.new()
					$user.email:=$email
					$user.lastname:=$lastname
					$user.firstname:=$firstname
					$user.role:=$role
					$user.password:=Generate password hash:C1533($password)
					$user.active:=True:C214
					$user.commentMail:=True:C214
					$user.commentNotification:=True:C214
					$user.likeMail:=True:C214
					$user.likeNotification:=True:C214
					$user.save()
					$mail.personalizations:=[{to: [{$email: $email}]}]
					$mail.subject:="Your KnowBase account is created"
					$url:=""
					$html:="<!doctype html>"+\
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
						"<br/><strong style=\"color: #3976D0; font-size: 16px;\">"+$password+"</strong>"+\
						"<br/><br/>"+\
						"Click the button below to sign in with your new account:"+\
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
					$mail.content:=[{type: "text/html"; value: $html}]
					$mailingResult:=cs:C1710.Mailer.me.send($mail)  //added the =
					Web Form:C1735.addUser.hide()
					If ($mailingResult)
						Web Form:C1735.setMessage("Email sent successfuly!!")
					End if 
			End case 
		End if 
	End if 
	
	//Active vs inactive users distribution for dashboard pie chart
exposed Function userPieChart() : Collection
	var $stats : Collection:=[]
	var $users : cs:C1710.UserSelection:=This:C1470.all()
	$stats.push({label: "active"; value: $users.query("active = :1"; True:C214).length})
	$stats.push({label: "inactive"; value: $users.query("active = :1"; False:C215).length})
	return $stats
	
	//Top 20 users ranked by engagement (articles or comments, depending on role)
exposed Function topUsers($role : Text) : Collection
	var $stats : Collection:=[]
	var $values : Collection
	var $users : cs:C1710.UserSelection
	Case of 
		: ($role="")
			$users:=This:C1470.all().orderByFormula("this.articles.length"; ck descending:K85:8).slice(0; 20)
		: (($role="Admin") || ($role="Tutor"))
			$users:=This:C1470.query("role = :1"; $role).orderByFormula("this.articles.length"; ck descending:K85:8).slice(0; 20)
		: ($role="Learner")
			$users:=This:C1470.query("role = :1"; $role).orderByFormula("this.comments.length"; ck descending:K85:8).slice(0; 20)
	End case 
	$stats:=$users.extract("fullName"; "x"; "articles.length"; "y"; "comments.length"; "z"; "likes.length"; "t")
	
	return $stats