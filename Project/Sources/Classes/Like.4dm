Class extends DataClass

exposed function delete($article : cs.ArticleEntity)
	var $user: cs.UserEntity
	var $result: cs.ArticleSelection
	var $info: object
	if (session.storage.playload # null && session.storage.playload.ID # null)
		$user := ds.User.get(session.storage.playload.ID)
		$result := this.query("likedBy.ID = :1 and article.ID = :2"; $user.ID; $article.ID)
		$info := $result.drop()
		web Form.setWarning("You have disliked this article!")
		// TODO: delete Notification
		// ds.Notification.deleteNotification($user; $article; "like")
	end if 
	
exposed function add($article : cs.ArticleEntity)
	// TODO: redo it
	var $user; articleOwner: cs.UserEntity
	var $like: cs.LikeEntity
	var $info; emailObj: object
	var $html; url: text
	if (session.storage.playload # null && session.storage.playload.ID # null)
		articleOwner := $article.user
		$user := ds.User.get(session.storage.playload.ID)
		$like := this.new()
		$like.likeDate := current Date
		$like.likeTime := current Time
		$like.likedBy := $user
		$like.article := $article
		$info := $like.save()
		web Form.setMessage("You have liked this article!")
		if (articleOwner.likeNotification)
			ds.Notification.generateNotifs(articleOwner; $user; $article; "like"; ""; true)
		end if 
		if (articleOwner.likeMail)
			emailObj := {}
			emailObj.personalizations := [{to: [{email: articleOwner.email}]}]
			emailObj.subject := "New like on "+$article.title
			url := ""
			$html := "<!doctype html>"+\
				"<html lang=\"en-US\">"+\
				"<head>"+\
				"<meta content=\"text/$html; charset=utf-8\" http-equiv=\"Content-Type\" />"+\
				"<title>KnowBase Account Created</title>"+\
				"<meta name=\"description\" content=\"A $like has been added.\">"+\
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
				"New like added on "+$article.title+\
				"</h1>"+\
				"<span style=\"display:inline-block; vertical-align:middle; margin:29px 0 26px; border-bottom:1px solid #cecece; width:100px;\"></span>"+\
				"<p style=\"color:#455056; font-size:15px;line-height:24px; margin:0;\">"+\
				"A new like has been posted on your blog post titled "+$article.title+". We wanted to inform you of this activity so you can engage with your readers and foster a vibrant discussion around your content. "+\
				"<br/>"+\
				"<span style=\"font-weight:800; text-align:center; color:#3976D0; font-size:16px;\">"+$article.title+"</span>"+\
				"<br/>"+\
				"To see this like, simply visit the following link."+\
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
