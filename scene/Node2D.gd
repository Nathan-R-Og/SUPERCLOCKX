extends Node2D
var leapYears = 0

var time = {}
var seconds = 0.0
var totalSeconds
var minutes = 0
var totalMinutes = 0
var hours = 0
var totalHours
var days = 0
var dayOfMonth = 0
var dayOfWeek = 0
var dayOfYear = 0
var isDst = false
var month = 0
var monthOfYear = 0
var week = 0
var weekOfYear = 0
var years = 0
var yearsAfterChrist = 0
var yearsBeforeChrist = 4000


var daysInMonth = 0
const monthDays = [31,28,31,30,31,30,31,31,30,31,30,31,0]


var speedScale = 0.0

var leapYearTicked = false
var leapYear = false
var emulated = false
var biblical = false
var totals = false


# Called when the node enters the scene tree for the first time.
func _ready():
	var iterateSort = 0
	while iterateSort < $Control.get_child_count():
		$Control.get_child(iterateSort).rect_position = Vector2(32,32 + (32*iterateSort))
		iterateSort += 1

func _process(delta):

	
	if emulated == false:
		time = OS.get_datetime()
		if time["year"] % 4 == 0:
			leapYear = true
		else:
			leapYear = false
		leapYears = floor(time["year"]/4)
		#define days of month
		if time["month"] != 2:
			daysInMonth = monthDays[time["month"] - 1]
		else:
			if leapYear:
				daysInMonth = 29
			else:
				daysInMonth = monthDays[time["month"] - 1]
		if biblical == true:
			yearsAfterChrist = time["year"] + yearsBeforeChrist
		years = time["year"]
		seconds = time["second"]
		minutes = time["minute"]
		hours = time["hour"]
		var accumlateDays = time["month"] -1 
		var daysTotal = 0
		var storeYear = 0
		if biblical == false:
			storeYear = time["year"]
		else:
			storeYear = yearsAfterChrist
		var dayOfYearCount
		while storeYear > -1:
			while accumlateDays > -1:
				if accumlateDays != 2:
					daysTotal += monthDays[accumlateDays]
				else:
					if leapYear:
						daysTotal += 29
					else:
						daysTotal == monthDays[accumlateDays]
				accumlateDays -= 1
			if storeYear == time["year"]:
				dayOfYearCount = daysTotal
			accumlateDays = 12
			storeYear -= 1
		dayOfYear = dayOfYearCount + time["day"] + 1
		dayOfMonth = time["day"]
		daysTotal += dayOfMonth
		days = daysTotal
		dayOfWeek = time["weekday"] + 1
		isDst = time["dst"]
		if biblical == false:
			storeYear = time["year"]
		else:
			storeYear = yearsAfterChrist
		var monthTotal = 0
		while storeYear > 0:
			monthTotal += 12 * (12/10)
			storeYear -= 1
		monthOfYear = time["month"]
		monthTotal += monthOfYear
		month = monthTotal
		week = floor(days / 7)
		weekOfYear = floor(dayOfYear / 7)
	else:
		print(int($speedScale/multiplier.text))
		speedScale = ($speedScale.value * delta) * int($speedScale/multiplier.text)
		seconds += delta * speedScale
		minutes = int(floor(seconds / 60))
		hours = int(floor(minutes / 60))
		days = int(floor(hours / 24))
		var daysInYear = 0
		if leapYear:
			daysInYear = 366
			if leapYearTicked == false:
				leapYearTicked = true
				leapYears += 1
		else:
			leapYearTicked = false
			daysInYear = 365
		if days >= (years + 1) * (daysInYear):
			years += 1
		if monthOfYear == 12 and dayOfMonth == 31:
			monthOfYear = 1
		if leapYear == false:
			if dayOfMonth >= (monthDays[monthOfYear - 1]):
				monthOfYear += 1
		else:
			if dayOfMonth >= 29 and monthOfYear == 2:
				monthOfYear += 1
			else:
				if dayOfMonth >= (monthDays[monthOfYear - 1]):
					monthOfYear += 1
		dayOfMonth = int(floor((days + 1) % (monthDays[monthOfYear - 1] + 1)))
		leapYear = bool(years % 4 == 0)
	
	$TICKER1.rotation_degrees = (seconds/60.0)*360.0
	$TICKER2.rotation_degrees = (minutes/60.0)*360.0
	if totals == false:
		var goThroughChildren = 0
		$Control.get_child(goThroughChildren).text = "Seconds: " + String(seconds)
		goThroughChildren += 1
		$Control.get_child(goThroughChildren).text = "Minutes: " + String(minutes)
		goThroughChildren += 1
		$Control.get_child(goThroughChildren).text = "Hours: " + String(hours)
		goThroughChildren += 1
		$Control.get_child(goThroughChildren).text = "Day of Month: " + String(dayOfMonth)
		goThroughChildren += 1
		$Control.get_child(goThroughChildren).text = "Day of Week: " + String(dayOfWeek)
		goThroughChildren += 1
		$Control.get_child(goThroughChildren).text = "Day of Year: " + String(dayOfYear)
		goThroughChildren += 1
		$Control.get_child(goThroughChildren).text = "Week of year: " + String(weekOfYear)
		goThroughChildren += 1
		$Control.get_child(goThroughChildren).text = "Month of year: " + String(monthOfYear)
		goThroughChildren += 1
		if biblical == false:
			if emulated == false:
				$Control.get_child(goThroughChildren).text = "Year: " + String(years)
			else:
				$Control.get_child(goThroughChildren).text = "Year: " + String(years + 1)
		goThroughChildren += 1
		$Control.get_child(goThroughChildren).text = "Leap Years: " + String(leapYears)
		goThroughChildren += 1
		$Control.get_child(goThroughChildren).text = "Is Leap Year: " + String(leapYear)
		goThroughChildren += 1
		while goThroughChildren < $Control.get_child_count():
			$Control.get_child(goThroughChildren).text = ""
			goThroughChildren += 1
		
	else:
		var goThroughChildren = 0
		$Control.get_child(goThroughChildren).text = "Seconds: " + String(seconds)
		goThroughChildren += 1
		$Control.get_child(goThroughChildren).text = "Minutes: " + String(minutes)
		goThroughChildren += 1
		$Control.get_child(goThroughChildren).text = "Hours: " + String(hours)
		goThroughChildren += 1
		$Control.get_child(goThroughChildren).text = "Days: " + String(days)
		goThroughChildren += 1
		$Control.get_child(goThroughChildren).text = "Weeks: " + String(week)
		goThroughChildren += 1
		$Control.get_child(goThroughChildren).text = "Months: " + String(month)
		goThroughChildren += 1
		if biblical == false:
			if emulated == false:
				$Control.get_child(goThroughChildren).text = "Year: " + String(years)
			else:
				$Control.get_child(goThroughChildren).text = "Year: " + String(years + 1)
		else:
			$Control.get_child(goThroughChildren).text = "Year: " + String(yearsAfterChrist)
		goThroughChildren += 1
		$Control.get_child(goThroughChildren).text = "Leap Years: " + String(leapYears)
		goThroughChildren += 1
		$Control.get_child(goThroughChildren).text = "Is Leap Year: " + String(leapYear)
		goThroughChildren += 1
		while goThroughChildren < $Control.get_child_count():
			$Control.get_child(goThroughChildren).text = ""
			goThroughChildren += 1


func _on_totals_pressed():
	totals = $totals.pressed


func _on_biblical_pressed():
	biblical = $biblical.pressed


func _on_emulateStart_pressed():
	emulated = !emulated
	if emulated == true:
		seconds = 0.0
		minutes = 0
		hours = 0
		dayOfMonth = 0
		dayOfWeek = 1
		dayOfYear = 1
		week = 0
		weekOfYear = 1
		monthOfYear = 1
		month = 0
		years = 0
		leapYears = 0
		leapYear = false
