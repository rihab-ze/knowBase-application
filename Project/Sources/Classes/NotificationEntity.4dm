Class extends Entity

exposed function get notificationAge()->$message : text
	var $notificationDate: date
	var $notificationTime: time
	var $Time strings: text
	var $splitTime: collection
	var $dateLeft; timeLeft: integer
	if (not(this.isNew()))
		$notificationDate := date(this.creationDate)
		$notificationTime := time(this.creationTime)
		if ($notificationDate = current Date)
			timeLeft := current Time-$notificationTime
			$Time strings := string(timeLeft)
			$splitTime := Split string($Time strings; ":")
			$message := num($splitTime[0]) < 1 ? num($splitTime[1]) < 1 ? $splitTime[2]+" Seconds Ago" : $splitTime[1]+" Minutes Ago" : num($splitTime[0]) = 1 ? $splitTime[0]+" Hour Ago" : $splitTime[0]+" Hours Ago"
		else 
			$dateLeft := current Date-$notificationDate
			$message := $dateLeft = 1 ? string($dateLeft)+" Day Ago" : text($dateLeft)+" Days Ago"
		end if 
	end if

exposed function readNotification()
	this.isRead := true
	this.save()

exposed function unreadNotification()
	this.isRead := false
	this.save()