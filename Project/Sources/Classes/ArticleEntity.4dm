Class extends Entity

exposed Alias articleTags tags.tag
exposed Alias likedBy likes.likedBy

exposed Function get nbrLikes()->$result : Text
	$result:=(This:C1470.likes.length#0) ? String:C10(This:C1470.likes.length) : "0"
	
exposed Function get nbrComments()->$result : Text
	$result:=(This:C1470.comments.length#0) ? String:C10(This:C1470.comments.length) : "0"
	
exposed Function get nbrTags()->$result : Integer
	$result:=This:C1470.tags.length
	
	//To be tested after 4 days of the creation of the article
exposed Function get tagNew()->$result : Text
	var $creationDate; $limitNew : Date
	$creationDate:=This:C1470.creationDate
	$limitNew:=Add to date:C393($creationDate; 0; 0; 4)
	$result:=(Current date:C33>=$limitNew) ? "" : "New"
	
exposed Function get isLiked() : Boolean
	var $user : cs:C1710.UserEntity
	If ((Session:C1714.storage.playload#Null:C1517) && (Session:C1714.storage.playload.ID#Null:C1517))
		$user:=ds:C1482.User.get(Session:C1714.storage.playload.ID)
		return (This:C1470.likedBy.query("ID = :1"; $user.ID).length>0)
	End if 
	
exposed Function getTags() : cs:C1710.TagSelection
	return This:C1470.tags.tag.copy()
	
exposed Function saveArticle($tags : cs:C1710.TagSelection) : cs:C1710.ArticleEntity
	var $tag : cs:C1710.TagEntity
	var $articleTag : cs:C1710.ArticleTagEntity
	var $articleTags : cs:C1710.ArticleTagSelection
	var $tagsToDrop; $tagsToAdd : cs:C1710.TagSelection
	If (This:C1470.articleTags.length>0)
		$tagsToDrop:=This:C1470.articleTags.minus($tags)
		$articleTags:=$tagsToDrop.articles
		$articleTags.drop()
		$tagsToAdd:=$tags.minus(This:C1470.articleTags)
		For each ($tag; $tagsToAdd)
			$articleTag:=ds:C1482.ArticleTag.new()
			$articleTag.article:=This:C1470
			$articleTag.tag:=$tag
			$articleTag.save()
		End for each 
	Else 
		For each ($tag; $tags)
			$articleTag:=ds:C1482.ArticleTag.new()
			$articleTag.article:=This:C1470
			$articleTag.tag:=$tag
			$articleTag.save()
		End for each 
	End if 
	If (This:C1470.creationDate=Null:C1517)
		This:C1470.creationDate:=Current date:C33()
		This:C1470.creationTime:=Current time:C178()
	End if 
	This:C1470.save()
	
	return This:C1470