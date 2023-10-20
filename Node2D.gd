extends Node2D


export var hostTimeScale = 0.5
var time = 0.0

var mil = false
var amPM = ""

var yearSyn = []
var year = 2000
var currMonth = ""
var currDay = 0

var it = 0

const calender = [
	["January", 31, [null]],
	["February", 28, [ ["LEAP","set",29] ] ],
	["March", 31, [null]],
	["April", 30, [null]],
	["May", 31, [null]],
	["June", 30, [null]],
	["July", 31, [null]],
	["August", 31, [null]],
	["September", 30, [null]],
	["October", 31, [null]],
	["November", 30, [null]],
	["December", 31, [null]]
	
	
	
	
	
	
]





func year():
	var ye = 0
	var dayIT = 0
	while ye < year:
		var i = 0
		var getSyn = []
		var found = false
		if ye % 4 == 0:
			getSyn.append("LEAP")
		#$Label2.text = "EEK"
		while i < calender.size():
			
			
			
			
			var getMonth = calender[i]
			
			var dayContent = getMonth[1]
			var SYNCHECK = 0
			while SYNCHECK < getMonth[2].size() and getMonth[2][SYNCHECK] != null:
				if getSyn.find(getMonth[2][SYNCHECK][0], 0) != -1:
					#DO
					match getMonth[2][SYNCHECK][1]:
						"add":
							dayContent += getMonth[2][SYNCHECK][2]
						"set":
							dayContent = getMonth[2][SYNCHECK][2]
				SYNCHECK += 1
			dayIT += dayContent
			i += 1
		ye += 1
	return dayIT

func _process(delta):
	time += (delta * hostTimeScale)
	var seconds = int(floor(time))
	var minutes = int(floor(seconds / 60))
	var hours = int(floor(minutes / 60))
	var days = int(floor(hours/ 24)) + 1






	var ye = year
	var dayIT = year()
	while ye < year + 1:
		var i = 0
		var getSyn = []
		var found = false
		if ye % 4 == 0:
			getSyn.append("LEAP")
		#$Label2.text = "EEK"
		while i < calender.size():
			var getMonth = calender[i]
			
			var dayContent = getMonth[1]
			var SYNCHECK = 0
			while SYNCHECK < getMonth[2].size() and getMonth[2][SYNCHECK] != null:
				if getSyn.find(getMonth[2][SYNCHECK][0], 0) != -1:
					#DO
					match getMonth[2][SYNCHECK][1]:
						"add":
							dayContent += getMonth[2][SYNCHECK][2]
						"set":
							dayContent = getMonth[2][SYNCHECK][2]
				SYNCHECK += 1
			if days > dayIT and days >= dayIT + dayContent + 1:
				#if days is oob of month
				i += 1
				dayIT += dayContent
				if currMonth == calender[calender.size() - 1][0]:
					year = ye + 1
			elif days > dayIT and days < dayIT + dayContent + 1:
				found = true
				currDay = days - dayIT
				currMonth = getMonth[0]
				break
		if found == true:
			break
		ye += 1


	var parseSeconds = seconds % 60
	var parseMinutes = minutes % 60
	var parseHours = hours % 24
	var tempHours = String(parseHours)







	if mil == false:
		if parseHours < 12:
			amPM = "AM"
		elif parseHours >= 12:
			amPM = "PM"
		
		
		
		
		
		if parseHours == 0:
			tempHours = "12"
		elif parseHours >= 13:
			tempHours = String(parseHours - 12)

	$Label.text = tempHours.pad_zeros(2) + ":" + String(parseMinutes).pad_zeros(2) + ":" + String(parseSeconds).pad_zeros(2) + " " + amPM
	$Label2.text = String(currDay) + " " + currMonth
	$year.text = String(year + 1)
