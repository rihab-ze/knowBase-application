Class extends DataClass

function event restrict() : cs.ArticleSelection
	if (session # null)
		case of 
			: (session.hasPrivilege("WebAdmin"))
				return null
			: (session.hasPrivilege("admin"))
				return null
			: (session.hasPrivilege("tutor"))
				// TODO:
				return null
			: (session.hasPrivilege("learner"))
				return this.query("public = :1 "; true)
				//: (session.hasPrivilege("guest"))
			: (session.getPrivileges().length = 0)
				return this.query("public = :1 "; true)
		end case 
	else 
		return this.newSelection()
	end if 
	
exposed function getByFilter($filter : text) : cs.ArticleSelection
	var $articles: cs.ArticleSelection
	var $user: cs.UserEntity
	case of 
		: ($filter = "draft")
			$articles := this.query("published = null").orderBy("creationDate desc, creationTime desc")
		: ($filter = "published")
			$articles := this.query("published = :1"; true).orderBy("creationDate desc, creationTime desc")
		: ($filter = "archived")
			$articles := this.query("published = :1"; false).orderBy("creationDate desc, creationTime desc")
		else 
			$articles := this.newSelection()
	end case 
	if ((session.storage.playload # null) && (session.storage.playload.ID # null) && session.hasPrivilege("tutor"))
		$user := ds.User.get(session.storage.playload.ID)
		$articles := $articles.query("user.ID = :1"; $user.ID)
	end if 
	return $articles
	
exposed function $search($filter : text; $search : text; $category : cs.CategoryEntity; $tag : cs.TagEntity) : cs.ArticleSelection
	var $articles: cs.ArticleSelection
	var $user: cs.UserEntity
	case of 
		: ($filter = "draft")
			$articles := this.query("published = null and title = :1"; "@"+$search+"@").orderBy("creationDate desc, creationTime desc")
		: ($filter = "published")
			$articles := this.query("published = :1 and title = :2"; true; "@"+$search+"@").orderBy("creationDate desc, creationTime desc")
		: ($filter = "archived")
			$articles := this.query("published = :1 and title = :2"; false; "@"+$search+"@").orderBy("creationDate desc, creationTime desc")
		: ($filter = "liked")
			if ((session.storage.playload # null) && (session.storage.playload.ID # null))
				$user := ds.User.get(session.storage.playload.ID)
				$articles := $user.likedArticles.query("title = :1"; "@"+$search+"@").orderBy("creationDate desc, creationTime desc")
			end if 
		else 
			$articles := this.query("title = :1"; "@"+$search+"@").orderBy("creationDate desc, creationTime desc")
	end case 
	if ($category # null)
		$articles := $articles.query("category.ID = :1"; $category.ID)
	end if 
	if ($tag # null)
		$articles := $articles.query("articleTags.ID = :1"; $tag.ID)
	end if 
	if (($filter # "ALL") && (session.storage.playload # null) && (session.storage.playload.ID # null) && session.hasPrivilege("tutor"))
		$user := ds.User.get(session.storage.playload.ID)
		$articles := $articles.query("user.ID = :1"; $user.ID)
	end if 
	return $articles
	
exposed function getAvailableCategories() : cs.CategorySelection
	// because i used restrict, the result differs from a $user to another
	return this.all().category
	
exposed function getAvailableTags() : cs.TagSelection
	return this.all().articleTags
	
exposed function getStats() : object
	var $stats: object := {}
	var $articles: cs.ArticleSelection := this.all()
	$stats.total := $articles.length
	$stats.draft := $articles.query("published = null").length
	$stats.published := $articles.query("published = :1"; true).length
	$stats.archived := $articles.query("published = :1"; false).length
	$stats.public := $articles.query("public = :1"; true).length
	return $stats

exposed function articlePieChart(): collection
	var $stats: collection := []
	var $articles: cs.ArticleSelection := this.all()
	$stats.push({ label: "Published"; value: $articles.query("published = :1"; true).length})
	$stats.push({ label: "Draft"; value: $articles.query("published = null").length})
	return $stats
exposed function articleMostLikes(): collection
	var $stats: collection := []
	var $articles: cs.ArticleSelection := this.all().orderByFormula("this.likes.length"; ck descending).slice(0; 10)
	$stats := $articles.extract("title"; "x"; "likes.length"; "value")
	return $stats
