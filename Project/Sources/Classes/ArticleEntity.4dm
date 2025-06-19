Class extends Entity

exposed alias $articleTags $tags.tag
exposed alias likedBy likes.likedBy

exposed function get nbrLikes()->$result : text
	$result := (this.likes.length # 0) ? string(this.likes.length) : "0"
	
exposed function get nbrComments()->$result : text
	$result := (this.comments.length # 0) ? string(this.comments.length) : "0"
	
exposed function get nbrTags()->$result : integer
	$result := this.tags.length
	
	//To be tested after 4 days of the creation of the article
exposed function get tagNew()->$result : text
	var $creationDate; limitNew: date
	$creationDate := this.creationDate
	limitNew := add to Date($creationDate; 0; 0; 4)
	$result := (current Date >= limitNew) ? "" : "New"
	
exposed function get isLiked() : boolean
	var $user: cs.UserEntity
	if ((session.storage.playload # null) && (session.storage.playload.ID # null))
		$user := ds.User.get(session.storage.playload.ID)
		return (this.likedBy.query("ID = :1"; $user.ID).length > 0)
	end if 
	
exposed function getTags() : cs.TagSelection
	return this.tags.tag.copy()
	
exposed function checkTitle()->$result : boolean
	if ((this.title = "") || (this.title = null))
		web Form.setError("Title mustn't be empty!")
		$result := false
	else 
		$result := true
	end if 
	
exposed function saveArticle($tags : cs.TagSelection) : cs.ArticleEntity
	var $tag: cs.TagEntity
	var $articleTag: cs.ArticleTagEntity
	var $articleTags: cs.ArticleTagSelection
	var $tagsToDrop; tagsToAdd: cs.TagSelection
	if (this.articleTags.length > 0)
		$tagsToDrop := this.articleTags.minus($tags)
		$articleTags := $tagsToDrop.articles
		$articleTags.drop()
		tagsToAdd := $tags.minus(this.articleTags)
		for Each ($tag; tagsToAdd)
			$articleTag := ds.ArticleTag.new()
			$articleTag.article := this
			$articleTag.tag := $tag
			$articleTag.save()
		end for each 
	else 
		for Each ($tag; $tags)
			$articleTag := ds.ArticleTag.new()
			$articleTag.article := this
			$articleTag.tag := $tag
			$articleTag.save()
		end for each 
	end if 
	if (this.creationDate = null)
		this.creationDate := current Date()
		this.creationTime := current Time()
	end if 
	this.save()
	
	return this