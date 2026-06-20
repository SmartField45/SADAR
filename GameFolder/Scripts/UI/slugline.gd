extends Control
#=================
#ONREADY VARIABLES
#=================
@onready var panel: Panel = $Panel
@onready var label_chapter: Label = $Panel/VBoxContainer/LabelChapter
@onready var label_title: Label = $Panel/VBoxContainer/LabelTitle
@onready var sfx: AudioStreamPlayer2D = $SFX
#=========
#VARIABLES
#=========
var next_scene: String = ""
var chapter_text: String = ""
var title_text: String = ""

#=============
#TIMING CONFIG
#=============
const FADE_IN_DURATION: float = 0.8
const FADE_OUT_DURATION: float = 0.8
const HOLD_DURATION: float = 1.5
const GAP_BETWEEN_LINES: float = 0.4

#==============
#READY FUNCTION
#==============
func _ready() -> void:
	#-------------
	#Scene Manager
	#-------------
	var slugline_data = SceneManager.get_slugline_data()
	chapter_text = slugline_data.get("chapter", "")
	title_text   = slugline_data.get("title", "")
	next_scene   = slugline_data.get("next_scene", "")
	#-----------------
	#Set Text to Label
	#-----------------
	label_chapter.text = chapter_text
	label_title.text   = title_text
	#--------------
	#Label Modulate
	#--------------
	panel.modulate.a       = 1.0
	label_chapter.modulate.a = 0.0
	label_title.modulate.a   = 0.0
	#------------
	#Function Run
	#------------
	play_slugline()

#=============
#PLAY SLUGLINE
#=============
func play_slugline() -> void:
	#--------------------
	#Fade in LabelChapter
	#--------------------
	var tween_chapter := create_tween()
	tween_chapter.tween_property(label_chapter, "modulate:a", 1.0, FADE_IN_DURATION)
	SFX()
	await tween_chapter.finished
	#---------
	#Gap Timer
	#---------
	await get_tree().create_timer(GAP_BETWEEN_LINES).timeout
	#------------------
	#Fade in LabelTitle
	#------------------
	var tween_title := create_tween()
	tween_title.tween_property(label_title, "modulate:a", 1.0, FADE_IN_DURATION)
	SFX()
	await tween_title.finished
	#---------
	#Gap Timer
	#---------
	await get_tree().create_timer(HOLD_DURATION).timeout
	#--------
	#Fade Out
	#--------
	var tween_out := create_tween()
	tween_out.set_parallel(true)
	tween_out.tween_property(label_chapter, "modulate:a", 0.0, FADE_OUT_DURATION)
	tween_out.tween_property(label_title,   "modulate:a", 0.0, FADE_OUT_DURATION)
	await tween_out.finished
	#------------
	#Pindah scene
	#------------
	if next_scene != "":
		SceneManager.change_scene(next_scene)
	else:
		push_error("SLUGLINE ERROR: next_scene kosong!")
#============
#SFX SETTINGS
#============
func SFX() -> void:
	sfx.pitch_scale = randf_range(0.95, 1.05)
	sfx.volume_db = randf_range(-6.0, -3.0)
	sfx.stop()
	sfx.play()
