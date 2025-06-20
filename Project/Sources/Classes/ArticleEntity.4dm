Class extends Entity

exposed Alias articleTags tags.tag
exposed Alias likedBy likes.likedBy

exposed Function get nbrLikes()->$result : Text
	$result:=(This.likes.length#0) ? String(This.likes.length) : "0"
	
exposed Function get nbrComments()->$result : Text
	$result:=(This.comments.length#0) ? String(This.comments.length) : "0"
	
exposed Function get nbrTags()->$result : Integer
	$result:=This.tags.length
	
	//To be tested after 4 days of the creation of the article
exposed Function get tagNew()->$result : Text
	var $creationDate; $limitNew : Date
	$creationDate:=This.creationDate
	$limitNew:=Add to date($creationDate; 0; 0; 4)
	$result:=(Current date>=$limitNew) ? "" : "New"
	
exposed Function get isLiked() : Boolean
	var $user : cs.UserEntity
	If ((Session.storage.playload#Null) && (Session.storage.playload.ID#Null))
		$user:=ds.User.get(Session.storage.playload.ID)
		return (This.likedBy.query("ID = :1"; $user.ID).length>0)
	End if 
	
exposed Function getTags() : cs.TagSelection
	return This.tags.tag.copy()
	
exposed Function checkTitle()->$result : Boolean
	If ((This.title="") || (This.title=Null))
		Web Form.setError("Title mustn't be empty!")
		$result:=False
	Else 
		$result:=True
	End if 
	
exposed Function saveArticle($tags : cs.TagSelection) : cs.ArticleEntity
	var $tag : cs.TagEntity
	var $articleTag : cs.ArticleTagEntity
	var $articleTags : cs.ArticleTagSelection
	var $tagsToDrop; tagsToAdd : cs.TagSelection
	If (This.articleTags.length>0)
		$tagsToDrop:=This.articleTags.minus($tags)
		$articleTags:=$tagsToDrop.articles
		$articleTags.drop()
		tagsToAdd:=$tags.minus(This.articleTags)
		For each ($tag; tagsToAdd)
			$articleTag:=ds.ArticleTag.new()
			$articleTag.article:=This
			$articleTag.tag:=$tag
			$articleTag.save()
		End for each 
	Else 
		For each ($tag; $tags)
			$articleTag:=ds.ArticleTag.new()
			$articleTag.article:=This
			$articleTag.tag:=$tag
			$articleTag.save()
		End for each 
	End if 
	If (This.creationDate=Null)
		This.creationDate:=Current date()
		This.creationTime:=Current time()
	End if 
	This.save()
	
	return This