//%attributes = {}

var $ES: 4D.EntitySelection

$ES := ds.Setting.all().drop()
$ES := ds.Tag.all().drop()
$ES := ds.Category.all().drop()
$ES := ds.Comment.all().drop()
$ES := ds.Like.all().drop()
$ES := ds.Notification.all().drop()
$ES := ds.ArticleTag.all().drop()
$ES:= ds.User.all().drop()
$ES := ds.Article.all().drop()