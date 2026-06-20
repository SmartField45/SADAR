extends Node2D
#================
#ONREADY VARIABLE
#================
@onready var investigate_hint: Label = $CanvasLayer/InvestigateHint
@onready var confront_btn: Button = $CanvasLayer/ConfrontButton
#========
#CONSTANT
#========
const CHAPTER_PATH    = "res://Scripts/JSON/Chapter1Part1.json"
const MIN_EVIDENCE    = 3   ## minimal bukti sebelum bisa konfrontasi
#======
#READY
#======
func _ready() -> void:
	#-----------
	#Hide UI
	#-----------
	investigate_hint.visible = false
	confront_btn.visible     = false
	#---------------
	#Connect Signals
	#---------------
	GameManager.evidence_added.connect(_on_evidence_added)
	confront_btn.pressed.connect(_start_confrontation)
	#-----------
	#Load & Start
	#-----------
	DialogBox.load_chapter(CHAPTER_PATH)
	DialogBox.start("Start")
	#------------------
	#Wait Opening Selesai
	#------------------
	await DialogBox.dialog_finished
	_start_investigation()
#===================
#START INVESTIGATION
#===================
func _start_investigation() -> void:
	#-----------
	#Show Hint
	#-----------
	investigate_hint.visible = true
	investigate_hint.text    = "🔍 Click an object to inspect"
#==============
#EVIDENCE ADDED
#==============
func _on_evidence_added(_ev: Dictionary) -> void:
	#------------------
	#Check Enough Proof
	#------------------
	if GameManager.get_evidence_count() >= MIN_EVIDENCE:
		_unlock_confrontation()
#====================
#UNLOCK CONFRONTATION
#====================
func _unlock_confrontation() -> void:
	#-----------
	#Show Button
	#-----------
	confront_btn.visible     = true
	investigate_hint.visible = false
	NotificationSystem.show_notif("Enough evidence, confront the suspect.")
#==================
#START CONFRONTATION
#==================
func _start_confrontation() -> void:
	#---------------
	#Return Function
	#---------------
	if EvidencePanel.panel.visible:
		return
	#-----------
	#Hide Button
	#-----------
	confront_btn.visible = false
	#--------------
	#Start Dialog
	#--------------
	DialogBox.start("Confrontation_Start")
	await DialogBox.dialog_finished
	#----------
	#Check End
	#----------
	_check_ending()
#============
#CHECK ENDING
#============
func _check_ending() -> void:
	#--------
	#Variable
	#--------
	var j: int = GameManager.justice_meter
	var e: int = GameManager.get_evidence_count()
	#-----------
	#Good Ending
	#-----------
	if j >= 60 and e >= MIN_EVIDENCE:
		DialogBox.start("Ending_Good")
	#----------
	#Bad Ending
	#----------
	else:
		DialogBox.start("Ending_Bad")
	#----------
	#Wait Then Save
	#----------
	await DialogBox.dialog_finished
	GameManager.save_game()
	SceneManager.change_scene("res://Scenes/UI/SummaryScreen.tscn")
