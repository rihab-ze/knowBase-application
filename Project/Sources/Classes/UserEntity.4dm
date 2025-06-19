Class extends Entity

exposed alias likedArticles likes.article

exposed function get fullName()->$result : text
	$result := this.firstname+" "+uppercase(this.lastname)
	
exposed function get nbrLikes()->$result : integer
	$result := this.likes.length
	
exposed function get nbrComments()->$result : integer
	$result := this.comments.length
	
exposed function get nbrArticles()->$result : integer
	$result := this.articles.query("published = true").length
	
exposed function get status()->$result : text
	if ((this.active = null) || not(this.active))
		$result := "disabled"
	else 
		$result := "enabled"
	end if 

exposed function haveNotifs()->$result: boolean
	$result := (this.notifications.query("isRead = :1"; false).length > 0)
	
exposed function getLikedArticles()->$result : cs.ArticleSelection
	$result := this.likedArticles
	$result := $result.orderBy("creationDate desc, creationTime desc")
	
exposed function updatePassword($password : text; $repassword : text)
	var $info: object
	var $html: text
	var $email: object := {personalizations: []}
	if ($password # "" && $repassword # "")
		if ($password # $repassword)
			web Form.setWarning("Password don't match")
		else 
			this.password := Generate password hash($password)
			$info := this.save()
			if ($info.success)
				web Form.setMessage("Your Password has been changed")
				$email.personalizations := [{to: [{$email: this.email}]}]
				$email.subject := "Your KnowBase password has been changed"
				// TODO: change the mail
				$html := "\r<!doctype html>\r<html lang=\"en-US\">\r\r<head>\r    <meta content=\"text/$html; charset=utf-8\" http-equiv=\"Content-Type\" />\r    <title>Creation knowBase Account </title>\r    <meta name=\"description\" content=\"Creation knowBase Account.\">\r    <style type=\"te"+"xt/css\">\r        a:hover {text-decoration: underline !important;}\r    </style>\r</head>\r\r<body marginheight=\"0\" topmargin=\"0\" marginwidth=\"0\" style=\"margin: 0px; background-color: #f2f3f8;\" leftmargin=\"0\">\r    <!--100% body table-->\r    <table cellspac"+"ing=\"0\" border=\"0\" cellpadding=\"0\" width=\"100%\" bgcolor=\"#f2f3f8\"\r        style=\"@import url(https://fonts.googleapis.com/css?family=Rubik:300; 400; 500; 700|Open+Sans:300; 400; 600; 700); font-family: 'Open Sans', sans-serif;\">\r        <tr>\r            <td"+">\r                <table style=\"background-color: #f2f3f8; max-width:670px;  margin:0 auto;\" width=\"100%\" border=\"0\"\r                    align=\"center\" cellpadding=\"0\" cellspacing=\"0\">\r                    <tr>\r                        <td style=\"height"+":80px;\">&nbsp;</td>\r                    </tr>\r                    <tr>\r                        <td style=\"text-align:center;\">\r                          <a href=\"https://knowBase.com\" title=\"logo\" target=\"_blank\">\r                            <img widt"+"h=\"200\" src=\"https://imgtr.ee/images/2023/08/31/8572866167474de9dde641fe8a3eed1d.png\" title=\"logo\" alt=\"logo\">\r                          </a>\r                        </td>\r                    </tr>\r                    <tr>\r                        <td "+"style=\"height:20px;\">&nbsp;</td>\r                    </tr>\r                    <tr>\r                        <td>\r                            <table width=\"95%\" border=\"0\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\"\r                                s"+"tyle=\"max-width:670px;background:#fff; border-radius:3px; text-align:center;-webkit-box-shadow:0 6px 18px 0 rgba(0; 0; 0; .06);-moz-box-shadow:0 6px 18px 0 rgba(0; 0; 0; .06);box-shadow:0 6px 18px 0 rgba(0; 0; 0; .06);\">\r                             <tr>\r     "+"                               <td style=\"height:40px;\">&nbsp;</td>\r                                </tr>\r                                <tr>\r                                    <td style=\"padding:0 35px;\">\r                                      <h1 s"+"tyle=\"color:#1e1e2d; font-weight:500; margin:0;font-size:32px;font-family:'Rubik',sans-serif;\">Admin\r                                            send you an invitation to log in </h1>\r                                     <span\r                        "+"                    style=\"display:inline-block; vertical-align:middle; margin:29px 0 26px; border-bottom:1px solid #cecece; width:100px;\"></span>\r                                        <p style=\"color:#455056; font-size:15px;line-height:24px; margin"+":0;\">\r                                            We cannot simply send you your password. A unique password to your\r                                            account to complete your account set up : <br/> <span  style=\"font-weight:800; text-align:"+"center; color:#3976D0; font-size:16px;\" >"+$password+"</span> <br/>  To complete  your account set up, click the\r                                            following link and sign in with given Password.\r                                        </p>\r                                        <a href=\"https:"+"//dev-9e4d4c3f-3701-4fab-a4a3-50c9f6fcacf3.staging-public.4dcloudtest.com/\"\r                                            style=\"background:#3976D0;text-decoration:none !important; font-weight:500; margin-top:35px; color:#fff;text-transform:uppercase; f"+"ont-size:14px;padding:10px 24px;display:inline-block;border-radius:50px;\">Sign\r                                            in</a>\r                                    </td>\r                                </tr>\r                                <tr>\r    "+"                                <td style=\"height:40px;\">&nbsp;</td>\r                                </tr>\r                            </table>\r                        </td>\r                    <tr>\r                        <td style=\"height:20px;\">&nb"+"sp;</td>\r                    </tr>\r                    <tr>\r                        <td style=\"text-align:center;\">\r                            <p style=\"font-size:14px; color:rgba(69; 80; 86; 0.7411764705882353); line-height:18px; margin:0 0 0;\">&cop"+"y; <strong>www.knowBase.com</strong></p>\r                        </td>\r                    </tr>\r                    <tr>\r                        <td style=\"height:80px;\">&nbsp;</td>\r                    </tr>\r                </table>\r            </td>"+"\r        </tr>\r    </table>\r</body>\r\r</html>"
				$email.content := [{type: "text/html"; value: $html}]
				cs.Mailer.me.send($email)
			end if 
		end if 
	else 
		web Form.setWarning("Please fill all required fields")
	end if 
exposed function readAllNotifs()
	var $notification: cs.NotificationEntity
	var $userNotifs: cs.NotificationSelection
	$userNotifs := this.notifications
	for Each ($notification; $userNotifs)
		$notification.readNotification()
	end for each 
	
exposed function unreadAllNotifs()
	var $notification: cs.NotificationEntity
	var $userNotifs: cs.NotificationSelection
	$userNotifs := this.notifications
	for Each ($notification; $userNotifs)
		$notification.unreadNotification()
	end for each