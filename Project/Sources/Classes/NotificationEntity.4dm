Class extends Entity

exposed Function get notificationAge()->$message : Text
	var $notificationDate : Date
	var $notificationTime : Time
	var $Timestrings : Text
	var $splitTime : Collection
	var $dateLeft; $timeLeft : Integer
	If (Not:C34(This:C1470.isNew()))
		$notificationDate:=Date:C102(This:C1470.creationDate)
		$notificationTime:=Time:C179(This:C1470.creationTime)
		If ($notificationDate=Current date:C33)
			timeLeft:=Current time:C178-$notificationTime
			$Timestrings:=String:C10($timeLeft)
			$splitTime:=Split string:C1554($Timestrings; ":")
			$message:=Num:C11($splitTime[0])<1 ? Num:C11($splitTime[1])<1 ? $splitTime[2]+" Seconds Ago" : $splitTime[1]+" Minutes Ago" : Num:C11($splitTime[0])=1 ? $splitTime[0]+" Hour Ago" : $splitTime[0]+" Hours Ago"
		Else 
			$dateLeft:=Current date:C33-$notificationDate
			$message:=$dateLeft=1 ? String:C10($dateLeft)+" Day Ago" : String:C10($dateLeft)+" Days Ago"
		End if 
	End if 
	
exposed Function readNotification()
	This:C1470.isRead:=True:C214
	This:C1470.save()
	
exposed Function unreadNotification()
	This:C1470.isRead:=False:C215
	This:C1470.save()