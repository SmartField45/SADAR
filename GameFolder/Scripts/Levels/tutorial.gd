extends Node2D
## Tutorial.gd
## Attach ke root node scene Tutorial
#================
#ONREADY VARIABLE
#================
@onready var investigate_hint = $UI/InvestigateHint
@onready var confront_btn     = $UI/ConfrontButton
#========
#CONSTANT
#========
const CHAPTER_PATH = "res://Scripts/JSON/Tutorial.json"
const MIN_EVIDENCE = 2
#======
#READY
#======
func _ready() -> void:
	#---------
	#Hide UI
	#---------
	investigate_hint.visible = false
	confront_btn.visible     = false
	#---------------
	#Connect Signals
	#---------------
	GameManager.evidence_added.connect(_on_evidence_added)
	confront_btn.pressed.connect(_start_confrontation)
	#-----------
	#Reset Dulu
	#-----------
	GameManager.reset_game()
	#-----------
	#Load & Start
	#-----------
	DialogBox.load_chapter(CHAPTER_PATH)
	DialogBox.start("Pre-Start")
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
	investigate_hint.text    = "Klik objek untuk memeriksa"
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
	NotificationSystem.show_notif("Bukti cukup! Saatnya konfrontasi.")
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
	DialogBox.start("tut_konfrontasi")
	await DialogBox.dialog_finished
	#-----------------
	#Langsung ke Level 1
	#-----------------
	GameManager.reset_game()
	SceneManager.show_slugline(
		"KASUS #1",
		"Jempol Berbisa",
		"res://Scenes/Levels/Level1.tscn"
	)
