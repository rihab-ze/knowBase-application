Class extends Entity

exposed Function get commentAge()->$message : Text
	var $commentDate : Date
	var $commentTime; $timeLeft : Time
	var $dateLeft : Integer
	var $splitTime : Collection
	
	If (Not:C34(This:C1470.isNew()))
		$commentDate:=Date:C102(This:C1470.creationDate)
		$commentTime:=Time:C179(This:C1470.creationTime)
		If ($commentDate=Current date:C33)
			$timeLeft:=Current time:C178-$commentTime
			$message:=String:C10($timeLeft; Hour min sec:K7:3)
		Else 
			$dateLeft:=Current date:C33-$commentDate
			$message:=($dateLeft=1) ? String:C10($dateLeft)+" Day Ago" : String:C10($dateLeft)+" Days Ago"
		End if 
	End if 
	
exposed Function create()
	TRACE:C157
	var $user; $articleOwner : cs:C1710.UserEntity
	var $info; $emailObj : Object
	var $html; $url : Text
	If ((Session:C1714.storage.playload#Null:C1517) && (Session:C1714.storage.playload.ID#Null:C1517) && (Length:C16(This:C1470.content)>0))
		$user:=ds:C1482.User.get(Session:C1714.storage.playload.ID)
		$articleOwner:=This:C1470.article.user
		This:C1470.creationDate:=Current date:C33
		This:C1470.creationTime:=Current time:C178
		This:C1470.user:=$user
		$info:=This:C1470.save()
		Web Form:C1735.setMessage("Comment added successfully")
		If ($articleOwner.commentNotification=True:C214)
			ds:C1482.Notification.generateNotifs($articleOwner; $user; This:C1470.article; "comment"; This:C1470.content; True:C214)  // to modify
		End if 
		If ($articleOwner.commentMail=True:C214)
			$emailObj:={personalizations: []}
			$emailObj.personalizations:=[{to: [{email: $articleOwner.email}]}]
			$emailObj.subject:="New Comment on "+This:C1470.article.title
			$url:=""
			$html:="<!doctype html>"+\
				"<html lang=\"en-US\">"+\
				"<head>"+\
				"<meta content=\"text/$html; charset=utf-8\" http-equiv=\"Content-Type\" />"+\
				"<title>KnowBase Account Created</title>"+\
				"<meta name=\"description\" content=\"A comment has been added.\">"+\
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
				"<h1 style=\"color:#1e1e2d; font-weight:500; margin:0;font-size:32px;font-family:'Rubik',sans-serif;\">"+\
				"New Comment added on"+This:C1470.article.title+\
				"</h1>"+\
				"<span style=\"display:inline-block; vertical-align:middle; margin:29px 0 26px; border-bottom:1px solid #cecece; width:100px;\"></span>"+\
				"<p style=\"color:#455056; font-size:15px;line-height:24px; margin:0;\">"+\
				"A new comment has been posted on your blog post titled "+\
				"<strong>"+This:C1470.article.title+"</strong>. We wanted to inform you of this activity so you can engage with your readers and foster a vibrant discussion around your content. <br/>"+\
				"To respond to this comment, simply visit the following link."+\
				"</p>"+\
				"<a href=\""+$url+"\""+\
				"style=\"background:#3976D0;text-decoration:none !important; font-weight:500; margin-top:35px; color:#fff;text-transform:uppercase; font-size:14px;padding:10px 24px;display:inline-block;border-radius:50px;\">"+\
				"Show"+\
				"</a>"+\
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
		End if 
	End if 
	
exposed Function checkLengthComment()->$result : Integer
	var $Vlength : Integer
	$Vlength:=(This:C1470.content=Null:C1517) ? 0 : Length:C16(This:C1470.content)
	$result:=600-$Vlength