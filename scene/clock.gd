extends Node2D


var totals = {
	"milliseconds": 0,
	"seconds": 0,
	"minutes": 0,
	"hours": 0,
	"days": 0,
	"weeks": 0,
	"months": 0,
	"years": 0,
}
var current = {
	"millisecond": 0,
	"second": 0,
	"minute": 0,
	"hour": 0,
	"day": 0,
	"weekday": 0,
	"yearday": 0,
	"week": 0,
	"monthweek": 0,
	"month": 0,
	"year": 0,
	"leapYear": 0,
	"normalDate": "",
	"properDate": "",
	"biblicalEra": "BC"
}
const months = {
	0: 31,
	1: 28,
	2: 31,
	3: 30,
	4: 31,
	5: 30,
	6: 31,
	7: 31,
	8: 30,
	9: 31,
	10: 30,
	11: 31,
}
const Month = ["January", "Ferbruary",
"March", "April", "May", "June", "July",
"August", "September", "October",
"November", "December"
]

const Weekday = ["Sunday", "Monday",
"Tuesday", "Wednesday", "Thursday",
"Friday", "Saturday"]

var theNumber = 62167219200

var silly = -theNumber


func _ready():
	$Options/system.connect("pressed", Callable(self, "offset"))
func offset():
	silly += -theNumber if $Options/system.button_pressed else 0
func getOffset(followingUnix):
	return silly if followingUnix else silly + theNumber

func _process(delta):
	print(Engine.get_frames_per_second())
	if $Options/system.button_pressed:
		silly = Time.get_unix_time_from_system() + (Time.get_time_zone_from_system().bias * 60)
	else:
		silly += delta * ($Options/speedScale.value if $Options/speedScale.value != 0 else 1) * float($Options/multiplier.text)
	var useSilly = silly
	
	var g = Time.get_datetime_dict_from_unix_time(useSilly)
	for key in g.keys():
		current[key] = g[key]
	useSilly = getOffset(false)

	totals.milliseconds = useSilly - floor(useSilly)
	totals.seconds = useSilly
	totals.minutes = useSilly / 60.0
	totals.hours = useSilly / (60.0 * 60.0)
	totals.days = useSilly / (60.0 * 60.0 * 24.0)
	totals.weeks = useSilly / (60.0 * 60.0 * 24.0 * 7.0)
	
	
	
	
	totals.months = 0
	totals.years = 0
	var dayCount = 0
	var dayToAdd = (4 * 365) + 1
	#inc by every 4 years
	#var sinch = int(floor(floor(totals.days) / dayToAdd))
	#dayCount = sinch * dayToAdd
	#totals.months += 48 * sinch
	while dayCount + dayToAdd < totals.days:
		dayCount += dayToAdd
		totals.months += 12 * 4
	totals.years = int(floor(totals.months / 12.0))
	#inc by year
	dayToAdd = 365 + int(totals.years % 4 == 0)
	while dayCount + dayToAdd < totals.days:
		dayCount += dayToAdd
		totals.months += 12
		totals.years = int(floor(totals.months / 12.0))
		dayToAdd = 365 + int(totals.years % 4 == 0)
	#inc by month (end)
	var febLep = totals.months % 12 == 1 and totals.years % 4 == 0
	dayToAdd = months[totals.months % 12] + int(febLep)
	while dayCount + dayToAdd < totals.days:
		dayCount += dayToAdd
		totals.months += 1
		totals.years = int(floor(totals.months / 12.0))
		febLep = totals.months % 12 == 1 and totals.years % 4 == 0
		dayToAdd = months[totals.months % 12] + int(febLep)
	totals.months += (totals.days - dayCount) / float(months[totals.months % 12])
	totals.years = totals.months / 12.0
	
	
	if $Options/biblical.button_pressed:
		totals.years += 4000
		current.biblicalEra = "AD" if current.year >= 4000 else "BC"
	else:
		current.biblicalEra = "N/A"
		
	
	
	
	
	current.leapYear = current.year % 4 == 0
	current.yearday = 0
	for i in current.month - 1:
		if current.leapYear and i == 1:
			current.yearday += months[i] + 1
		else:
			current.yearday += months[i]
	current.yearday += current.day
	current.week = int(floor(current.yearday / 7))
	current.monthweek = int(floor(current.day / 7))
	var date = "/".join([str(current.month).pad_zeros(2), str(current.day).pad_zeros(2), str(current.year).pad_zeros(4)])
	
	var threeAmInThe = "PM" if current.hour >= 12 else "AM"
	var hourAdd = current.hour if $Options/hr24.button_pressed else wrapi(current.hour % 12, 1, 13)
	var time = ":".join([str(hourAdd).pad_zeros(2), str(current.minute).pad_zeros(2), str(current.second).pad_zeros(2)])
	
	var arr = [time, date]
	if not $Options/hr24.button_pressed:
		arr.insert(1, threeAmInThe)
	current.normalDate = " ".join(arr)
		
	
	
	
	var ext = "th"
	var teen = int(str(current.day)[0]) == 1 and str(current.day).length() == 2
	if not teen:
		match int(str(current.day)[-1]):
			1:
				ext = "st"
			2:
				ext = "nd"
			3:
				ext = "rd"
	current.properDate = " ".join([Weekday[current.weekday], Month[current.month - 1], str(current.day) + ext + ",", str(current.year)])
	
	
	
	
	var useDict = current
	if $Options/totals.button_pressed:
		useDict = totals
	$Text.text = ""
	for key in useDict.keys():
		var namer = key.capitalize()
		$Text.text += namer + ": " + str(useDict[key]) + "\n"
	
	
	silly = wrapf(silly, -2000000000000000, 400000000000000)
	#it will be the heat death of the universe before you can reach the upper limits
	
	var calcSecond = fmod(totals.seconds, 60.0) if $Options/fineHands.button_pressed else current.second
	var calcMinute = fmod(totals.minutes, 60.0) if $Options/fineHands.button_pressed else current.minute
	var calcHour = fmod(totals.hours, 12.0) if $Options/fineHands.button_pressed else current.hour % 12
	$TICKER1.rotation_degrees = (calcSecond / 60.0) * 360
	$TICKER2.rotation_degrees = (calcMinute / 60.0) * 360
	$TICKER3.rotation_degrees = (calcHour / 12.0) * 360
	
