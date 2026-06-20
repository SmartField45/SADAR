extends Control
## SummaryHistory.gd
## Halaman khusus di Settings untuk lihat semua summary
##
## Scene structure:
##   Control
##   └── VBoxContainer
##       ├── TitleLabel         "Riwayat Kasus"
##       ├── ScrollContainer
##       │   └── SummaryList (VBoxContainer)  ← card summary masuk sini
##       └── BackButton
#================
#ONREADY VARIABLE
#================
@onready var summary_list = $ScrollContainer/SummaryList
@onready var back_btn     = $Back
#========
#CONSTANT
#========
const SUMMARY_DIR = "user://summaries/"
var font = "res://Fonts/PixelOperator-Bold.ttf"
#===============
#EXPORT VARIABLE
#===============
@export var summary_card_scene: PackedScene   ## drag SummaryCard.tscn di Inspector
#======
#READY
#======
func _ready() -> void:
	#-----
	#Load
	#-----
	_load_all_summaries()
#==================
#LOAD ALL SUMMARIES
#==================
func _load_all_summaries() -> void:
	#-----------
	#Clear List
	#-----------
	for child in summary_list.get_children():
		child.queue_free()
	#-----------
	#Check Dir
	#-----------
	if not DirAccess.dir_exists_absolute(SUMMARY_DIR):
		_show_empty()
		return
	#----------
	#Get Files
	#----------
	var dir   = DirAccess.open(SUMMARY_DIR)
	var files = []
	dir.list_dir_begin()
	var fname = dir.get_next()
	while fname != "":
		if fname.ends_with(".cfg"):
			files.append(fname)
		fname = dir.get_next()
	dir.list_dir_end()
	#--------------
	#Empty Handling
	#--------------
	if files.is_empty():
		_show_empty()
		return
	#------
	#Sort (terbaru di atas)
	#------
	files.sort()
	files.reverse()
	#----------
	#Build Card
	#----------
	for f in files:
		_build_card(SUMMARY_DIR + f)
#============
#BUILD CARD
#============
func _build_card(path: String) -> void:
	#----------
	#Load File
	#----------
	var config = ConfigFile.new()
	if config.load(path) != OK:
		return
	#----------
	#Read Data
	#----------
	var chapter  = config.get_value("summary", "chapter",        0)
	var title    = config.get_value("summary", "title",          "?")
	var date     = config.get_value("summary", "date",           "?")
	var justice  = config.get_value("summary", "justice_meter",  0)
	var ev_count = config.get_value("summary", "evidence_count", 0)
	var ending   = config.get_value("summary", "ending",         "?")
	var verdict  = config.get_value("summary", "verdict",        "?")
	#-----------
	#Instantiate
	#-----------
	if not summary_card_scene:
		_build_card_from_code(chapter, title, date, justice, ev_count, ending, verdict)
		return
	var card = summary_card_scene.instantiate()
	card.get_node("VBoxContainer/HeaderLabel").text  = "Case #%d - %s" % [chapter, title]
	card.get_node("VBoxContainer/DateLabel").text    = date.substr(0, 10)
	card.get_node("VBoxContainer/JusticeLabel").text = "Justice: %d/100  |  Bukti: %d  |  Ending: %s" % [justice, ev_count, ending]
	card.get_node("VBoxContainer/VerdictLabel").text = verdict
	summary_list.add_child(card)
#======================
#BUILD CARD (FALLBACK)
#======================
func _build_card_from_code(chapter: int, title: String, date: String, justice: int, ev_count: int, ending: String, verdict: String) -> void:
	#----------
	#Container
	#----------
	var card    = PanelContainer.new()
	var vbox    = VBoxContainer.new()
	#-------
	#Labels
	#-------
	var header  = Label.new()
	var datelbl = Label.new()
	var stats   = Label.new()
	var verdlbl = Label.new()
	#----------
	#Set Text
	#----------
	header.text  = "Kasus #%d — %s" % [chapter, title]
	datelbl.text = date.substr(0, 10)
	stats.text   = "Justice: %d/100  |  Bukti: %d  |  Ending: %s" % [justice, ev_count, ending]
	verdlbl.text = verdict
	#----------
	#Add Child
	#----------
	vbox.add_child(header)
	vbox.add_child(datelbl)
	vbox.add_child(stats)
	vbox.add_child(verdlbl)
	card.add_child(vbox)
	summary_list.add_child(card)
#=============
#EMPTY STATE
#=============
func _show_empty() -> void:
	var lbl      = Label.new()
	var loaded_font = load(font)
	
	lbl.add_theme_font_override("font", loaded_font)
	lbl.add_theme_font_size_override("font_size", 24)
	lbl.text     = "Belum ada kasus yang ditangani, tekan 'Start' untuk memulai"
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	summary_list.add_child(lbl)
#===========
#BACK BUTTON
#===========
func _on_back_pressed() -> void:
	SceneManager.change_scene("res://Scenes/UI/MainMenu.tscn")
