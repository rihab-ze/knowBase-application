Class extends DataClass

Function event restrict() : cs:C1710.ArticleSelection
	If (Session:C1714#Null:C1517)
		Case of 
			: (Session:C1714.hasPrivilege("WebAdmin"))
				return Null:C1517
			: (Session:C1714.hasPrivilege("admin"))
				return Null:C1517
			: (Session:C1714.hasPrivilege("tutor"))
				// TODO:
				return Null:C1517
			: (Session:C1714.hasPrivilege("learner"))
				return This:C1470.query("public = :1 "; True:C214)
				//: (session.hasPrivilege("guest"))
			: (Session:C1714.getPrivileges().length=0)
				return This:C1470.query("public = :1 "; True:C214)
		End case 
	Else 
		return This:C1470.newSelection()
	End if 
	
exposed Function getByFilter($filter : Text) : cs:C1710.ArticleSelection
	var $articles : cs:C1710.ArticleSelection
	var $user : cs:C1710.UserEntity
	Case of 
		: ($filter="draft")
			$articles:=This:C1470.query("published = null").orderBy("creationDate desc, creationTime desc")
		: ($filter="published")
			$articles:=This:C1470.query("published = :1"; True:C214).orderBy("creationDate desc, creationTime desc")
		: ($filter="archived")
			$articles:=This:C1470.query("published = :1"; False:C215).orderBy("creationDate desc, creationTime desc")
		Else 
			$articles:=This:C1470.newSelection()
	End case 
	If ((Session:C1714.storage.playload#Null:C1517) && (Session:C1714.storage.playload.ID#Null:C1517) && Session:C1714.hasPrivilege("tutor"))
		$user:=ds:C1482.User.get(Session:C1714.storage.playload.ID)
		$articles:=$articles.query("user.ID = :1"; $user.ID)
	End if 
	return $articles
	
exposed Function search($filter : Text; $search : Text; $category : cs:C1710.CategoryEntity; $tag : cs:C1710.TagEntity) : cs:C1710.ArticleSelection
	var $articles : cs:C1710.ArticleSelection
	var $user : cs:C1710.UserEntity
	Case of 
		: ($filter="draft")
			$articles:=This:C1470.query("published = null and title = :1"; "@"+$search+"@").orderBy("creationDate desc, creationTime desc")
		: ($filter="published")
			$articles:=This:C1470.query("published = :1 and title = :2"; True:C214; "@"+$search+"@").orderBy("creationDate desc, creationTime desc")
		: ($filter="archived")
			$articles:=This:C1470.query("published = :1 and title = :2"; False:C215; "@"+$search+"@").orderBy("creationDate desc, creationTime desc")
		: ($filter="liked")
			If ((Session:C1714.storage.playload#Null:C1517) && (Session:C1714.storage.playload.ID#Null:C1517))
				$user:=ds:C1482.User.get(Session:C1714.storage.playload.ID)
				$articles:=$user.likedArticles.query("title = :1"; "@"+$search+"@").orderBy("creationDate desc, creationTime desc")
			End if 
		Else 
			$articles:=This:C1470.query("title = :1"; "@"+$search+"@").orderBy("creationDate desc, creationTime desc")
	End case 
	If ($category#Null:C1517)
		$articles:=$articles.query("category.ID = :1"; $category.ID)
	End if 
	If ($tag#Null:C1517)
		$articles:=$articles.query("articleTags.ID = :1"; $tag.ID)
	End if 
	If (($filter#"ALL") && (Session:C1714.storage.playload#Null:C1517) && (Session:C1714.storage.playload.ID#Null:C1517) && Session:C1714.hasPrivilege("tutor"))
		$user:=ds:C1482.User.get(Session:C1714.storage.playload.ID)
		$articles:=$articles.query("user.ID = :1"; $user.ID)
	End if 
	return $articles
	
exposed Function getAvailableCategories() : cs:C1710.CategorySelection
	// because i used restrict, the result differs from a $user to another
	return This:C1470.all().category
	
exposed Function getAvailableTags() : cs:C1710.TagSelection
	return This:C1470.all().articleTags
	
exposed Function getStats() : Object
	var $stats : Object:={}
	var $articles : cs:C1710.ArticleSelection:=This:C1470.all()
	$stats.total:=$articles.length
	$stats.draft:=$articles.query("published = null").length
	$stats.published:=$articles.query("published = :1"; True:C214).length
	$stats.archived:=$articles.query("published = :1"; False:C215).length
	$stats.public:=$articles.query("public = :1"; True:C214).length
	return $stats
	
	//Distribution of published vs draft articles for dashboard pie chart.
exposed Function articlePieChart() : Collection
	var $stats : Collection:=[]
	var $articles : cs:C1710.ArticleSelection:=This:C1470.all()
	$stats.push({label: "Published"; value: $articles.query("published = :1"; True:C214).length})
	$stats.push({label: "Draft"; value: $articles.query("published = null").length})
	return $stats
	
	//Top 10 articles ranked by number of likes.
exposed Function articleMostLikes() : Collection
	var $stats : Collection:=[]
	var $articles : cs:C1710.ArticleSelection:=This:C1470.all().orderByFormula("this.likes.length"; ck descending:K85:8).slice(0; 10)
	$stats:=$articles.extract("title"; "x"; "likes.length"; "value")
	return $stats
	