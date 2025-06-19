Class extends DataClass

exposed function generateNotifs($userOwner : cs.UserEntity; $user : cs.UserEntity; $article : cs.ArticleEntity; $option : text; $content : text; $notified : boolean)->$notification : cs.NotificationEntity
	if ($notified = true)
		$notification := this.new()
		$notification.creationDate := current Date
		$notification.creationTime := current Time
		$notification.isRead := false
		$notification.user := $userOwner
		case of 
			: ($option = "like")
				$notification.message := $user.firstname+" "+$user.lastname+" has liked the article: \""+article.title+"\""
			: ($option = "comment")
				$notification.message := $user.firstname+" "+$user.lastname+" has commented on the article \""+article.title+"\": "+$content
			: ($option = "newArticle")
				$notification.message := "Your article \""+article.title+"\"has been posted successfully"
		end case 
		$notification.save()
	end if 
	
exposed function deleteNotification($user : cs.UserEntity; $article : cs.ArticleEntity; $option : text)
	var $notification: cs.NotificationSelection
	var $info: object
	// $user.artices.ID shouldn't work ??!!
	case of 
		: ($option = "like")
			$notification := this.query("user.ID = :1 and user.articles.ID = :2 and message = :3"; $user.ID; $article.ID; "@liked@")
		: ($option = "comment")
			$notification := this.query("user.ID = :1 and user.articles.ID = :2 and message = :3"; $user.ID; $article.ID; "@commented@")
		: ($option = "newArticle")
			$notification := this.query("user.ID = :1 and user.articles.ID = :2 and message = :3"; $user.ID; $article.ID; "@posted@")
	end case 
	$info := $notification.drop()