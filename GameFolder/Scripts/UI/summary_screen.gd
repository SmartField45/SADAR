extends Control
#================
#ONREADY VARIABLE
#================
@onready var title_label    = $VBoxContainer/TitleLabel
@onready var subtitle_label = $VBoxContainer/SubtitleLabel
@onready var date_label     = $VBoxContainer/DateLabel
@onready var justice_label  = $VBoxContainer/JusticeLabel
@onready var ending_label   = $VBoxContainer/EndingLabel
@onready var evidence_list  = $VBoxContainer/EvidenceList
@onready var verdict_label  = $VBoxContainer/VerdictLabel
@onready var continue_btn   = $VBoxContainer/ContinueButton
#========
#CONSTANT
#========
const SUMMARY_DIR  = "user://summaries/"
const NEXT_SCENE = "res://Scenes/UI/LevelSelect.tscn"
#======
#READY
#======
func _ready() -> void:
	#-------
	#Connect
	#-------
	continue_btn.pressed.connect(_on_continue_pressed)
	#----------
	#Build Data
	#----------
	var data = _build_summary_data()
	#---------
	#Show Data
	#---------
	_display_summary(data)
	#----
	#Save
	#----
	_save_summary(data)
	#-----------
	#Mark Level
	#-----------
	if not GameManager.completed_levels.has(GameManager.current_chapter):
		GameManager.completed_levels.append(GameManager.current_chapter)
	GameManager.save_game()
#===================
#BUILD SUMMARY DATA
#===================
func _build_summary_data() -> Dictionary:
	#--------
	#Variable
	#--------
	var j       = GameManager.justice_meter
	var ev      = GameManager.evidence
	var ending  = "Good" if j >= 60 and ev.size() >= 3 else "Bad"
	var verdict = _get_verdict(j, ev.size())
	var date    = Time.get_datetime_string_from_system()
	#------
	#Return
	#------
	return {
		"chapter":         GameManager.current_chapter,
		"title":           _get_level_title(),
		"date":            date,
		"justice_meter":   j,
		"evidence_count":  ev.size(),
		"evidence_list":   ev.duplicate(),
		"ending":          ending,
		"verdict":         verdict,
	}
#==========
#GET TITLE
#==========
func _get_level_title() -> String:
	match GameManager.current_chapter:
		1: return "Jempol Berbisa"
		2: return "Kabut Hitam"
		_: return "Kasus Tidak Diketahui"
#===========
#GET VERDICT
#===========
func _get_verdict(j: int, ev_count: int) -> String:
	if j >= 80 and ev_count >= 4:
		return "Penyelesaian Sempurna - Semua pihak memahami satu sama lain."
	elif j >= 60 and ev_count >= 3:
		return "Diselesaikan - Keadilan restoratif tercapai."
	elif j >= 40:
		return "Kurang Tuntas - Beberapa bukti terlewat."
	else:
		return "Gagal - Konfrontasi terlalu agresif."
#================
#DISPLAY SUMMARY
#================
func _display_summary(data: Dictionary) -> void:
	#------
	#Label
	#------
	title_label.text    = "— LAPORAN KASUS #%d —" % data["chapter"]
	subtitle_label.text = data["title"]
	date_label.text     = "Tanggal: " + data["date"].substr(0, 10)
	justice_label.text  = "Justice Meter: %d / 100" % data["justice_meter"]
	ending_label.text   = "Ending: " + data["ending"]
	verdict_label.text  = data["verdict"]
	#--------------
	#Evidence List
	#--------------
	for child in evidence_list.get_children():
		child.queue_free()
	for ev in data["evidence_list"]:
		var lbl      = Label.new()
		lbl.text     = "▸ " + ev.get("name", "?")
		evidence_list.add_child(lbl)
#=============
#SAVE SUMMARY
#=============
func _save_summary(data: Dictionary) -> void:
	#-----------
	#Create Dir
	#-----------
	if not DirAccess.dir_exists_absolute(SUMMARY_DIR):
		DirAccess.make_dir_absolute(SUMMARY_DIR)
	#---------
	#Filename
	#---------
	var filename = SUMMARY_DIR + "kasus%d_%s.cfg" % [
		data["chapter"],
		data["date"].replace(":", "-").replace(" ", "_")
	]
	#------
	#Save
	#------
	var config = ConfigFile.new()
	config.set_value("summary", "chapter",        data["chapter"])
	config.set_value("summary", "title",          data["title"])
	config.set_value("summary", "date",           data["date"])
	config.set_value("summary", "justice_meter",  data["justice_meter"])
	config.set_value("summary", "evidence_count", data["evidence_count"])
	config.set_value("summary", "ending",         data["ending"])
	config.set_value("summary", "verdict",        data["verdict"])
	config.save(filename)
#================
#CONTINUE BUTTON
#================
func _on_continue_pressed() -> void:
	SceneManager.change_scene(NEXT_SCENE)
