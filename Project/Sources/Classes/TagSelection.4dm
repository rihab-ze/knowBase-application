Class extends EntitySelection

exposed function addInArticle($tag : cs.TagEntity) : cs.TagSelection
	var $tagSel: cs.TagSelection := this.copy()
	if ($tagSel.length > 2)
		web Form.setWarning("You can only choose 3 tags!!")
		return $tagSel
	else 
		return $tagSel.add($tag)
	end if


exposed function remove($tag : cs.TagEntity): cs.TagSelection
	return this.minus($tag)
