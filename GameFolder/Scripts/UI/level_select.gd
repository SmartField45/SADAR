extends Control
#================
#ONREADY VARIABLE
#================
@onready var level_grid = $VBoxContainer/LevelGrid
#========
#CONSTANT
#========
const LEVELS = [
	{
		"id": 1,
		"title": "Kasus #1",
		"subtitle": "Jempol Berbisa",
		"scene": "res://Scenes/Levels/Level1.tscn",
		"slugline_chapter": "Case #1",
		"slugline_title": "Poisonous Thumb"
	},
	{
		"id": 2,
		"title":  "Kasus #2",
		"subtitle": "Kabut Hitam",
		"scene": "res://Scenes/Levels/Level2.tscn",
		"slugline_chapter": "Case #2",
		"slugline_title": "Dark Mist"
	},
]
@export var level_btn_scene: PackedScene
#======
#READY
#======
func _ready() -> void:
	_build_level_buttons()
#====================
#BUILD LEVEL BUTTONS
#====================
func _build_level_buttons() -> void:
	var completed = GameManager.completed_levels
	for level in LEVELS:
		#-----------
		#Instantiate
		#-----------
		var btn = level_btn_scene.instantiate()
		var is_locked = level["id"] > 1 and not (level["id"] - 1) in completed
		#---------
		#Set Text
		#---------
		btn.get_node("VBoxContainer/TitleLabel").text    = level["title"]
		btn.get_node("VBoxContainer/SubtitleLabel").text = level["subtitle"]
		btn.disabled = is_locked
		#-------
		#Connect
		#-------
		if not is_locked:
			var ldata = level
			btn.pressed.connect(func(): _on_level_pressed(ldata))
		level_grid.add_child(btn)
#================
#ON LEVEL PRESSED
#================
func _on_level_pressed(level: Dictionary) -> void:
	SceneManager.show_slugline(
		level["slugline_chapter"],
		level["slugline_title"],
		level["scene"]
	)
#===========
#BACK BUTTON
#===========
func _on_back_pressed() -> void:
	SceneManager.change_scene("res://Scenes/UI/MainMenu.tscn")
