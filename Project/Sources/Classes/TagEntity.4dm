Class extends Entity

exposed function remove()
	if(this.articles.length > 0)
		web Form.setWarning("You cannot remove a Tag linked to an article")
	else
		this.drop()
	end if