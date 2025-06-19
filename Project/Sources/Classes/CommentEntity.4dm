Class extends Entity

exposed function get commentAge()->$message : text
	var $commentDate: date
	var $commentTime; timeLeft: time
	var $dateLeft: integer
	var $Time strings: text
	var $splitTime: collection
	
	if (not(this.isNew()))
		$commentDate := date(this.creationDate)
		$commentTime := time(this.creationTime)
		if ($commentDate = current Date)
			timeLeft := current Time-$commentTime
			$message := string(timeLeft; Hour minSec)
		else 
			$dateLeft := current Date-$commentDate
			$message := ($dateLeft = 1) ? string($dateLeft)+" Day Ago" : text($dateLeft)+" Days Ago"
		end if 
	end if 
	
exposed function create()
	var $user; articleOwner: cs.UserEntity
	var $info; emailObj: object
	var $html; url: text
	if (session.storage.playload # null && session.storage.playload.ID # null && length(this.content) > 0)
		$user := ds.User.get(session.storage.playload.ID)
		articleOwner := this.article.user
		this.creationDate := current Date
		this.creationTime := current Time
		this.user := $user
		$info := this.save()
		web Form.setMessage("Comment added successfully")
		if (articleOwner.commentNotification)
			ds.Notification.generateNotifs(articleOwner; $user; this.article; "comment"; this.content; true)  // to modify
		end if 
		if (articleOwner.commentMail)
			emailObj := {personalizations: []}
			emailObj.personalizations := [{to: [{email: articleOwner.email}]}]
			emailObj.subject := "New Comment on "+this.article.title
			url := ""
			$html := "<!doctype html>"+\
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
				"New Comment added on"+this.article.title+\
				"</h1>"+\
				"<span style=\"display:inline-block; vertical-align:middle; margin:29px 0 26px; border-bottom:1px solid #cecece; width:100px;\"></span>"+\
				"<p style=\"color:#455056; font-size:15px;line-height:24px; margin:0;\">"+\
				"A new comment has been posted on your blog post titled "+\
				"<strong>"+this.article.title+"</strong>. We wanted to inform you of this activity so you can engage with your readers and foster a vibrant discussion around your content. <br/>"+\
				"To respond to this comment, simply visit the following link."+\
				"</p>"+\
				"<a href=\""+url+"\""+\
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
			emailObj.content := [{type: "text/html"; value: $html}]
			cs.Mailer.me.send(emailObj)
		end if 
	end if 
	
exposed function checkLengthComment()->$result : integer
	var $Vlength: integer
	$Vlength := (this.content = null) ? 0 : length(this.content)
	$result := 600-$Vlength