extends Control
#================
#ONREADY VARIABLE
#================
@onready var settings_panel: Panel = $SettingsPanel
@onready var sfx_slider: HSlider = $SettingsPanel/SlideContainer/SFXSlider
@onready var music_slider: HSlider = $SettingsPanel/SlideContainer/MusicSlider
@onready var ui_slider: HSlider = $SettingsPanel/SlideContainer/UISlider
#========
#CONSTANT
#========
const LEVEL1_PATH = "res://Scenes/Levels/Level1.tscn"
const SETTINGS_PATH = "user://settings.cfg"
#======
#READY
#======
func _ready() -> void:
	#-----------
	#Hide Panel
	#-----------
	settings_panel.visible = false
	#-----------
	#Load Audio
	#-----------
	_load_settings()
#============
#START BUTTON
#============
func _on_start_pressed() -> void:
	#--------
	#Variable
	#--------
	var save_exists = FileAccess.file_exists("user://savegame.cfg")
	#------------------
	#Load If Save Exist
	#------------------
	if save_exists:
		GameManager.load_game()
	else:
		GameManager.reset_game()
	SceneManager.change_scene("res://Scenes/UI/LevelSelect.tscn")
#===========
#QUIT BUTTON
#===========
func _on_quit_pressed() -> void:
	get_tree().quit()
#================
#SETTINGS BUTTON
#================
func _on_settings_pressed() -> void:
	settings_panel.visible = true
#====================
#SETTINGS BACK BUTTON
#====================
func _on_settings_back_pressed() -> void:
	settings_panel.visible = false
	_save_settings()
#==========
#RESET GAME
#==========
func _on_reset_pressed() -> void:
	GameManager.reset_game()
	NotificationSystem.show_notif("Data game direset.")
#============
#AUDIO SLIDER
#============
func _on_sfx_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
func _on_music_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
func _on_ui_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("UI"), linear_to_db(value))
#=============
#SAVE SETTINGS
#=============
func _save_settings() -> void:
	#--------
	#Variable
	#--------
	var config = ConfigFile.new()
	#----------------
	#Config Set Value
	#----------------
	config.set_value("audio","SFX", sfx_slider.value)
	config.set_value("audio","Music", music_slider.value)
	config.set_value("audio","UI", ui_slider.value)
	config.save(SETTINGS_PATH)
#=============
#LOAD SETTINGS
#=============
func _load_settings() -> void:
	#--------
	#Variable
	#--------
	var config = ConfigFile.new()
	#---------------
	#Return Function
	#---------------
	if config.load(SETTINGS_PATH) != OK:
		return
	#----------
	#Load Value
	#----------
	sfx_slider.value   = config.get_value("audio", "SFX",   1.0)
	music_slider.value = config.get_value("audio", "Music", 1.0)
	ui_slider.value    = config.get_value("audio", "UI",    1.0)
	#-----------
	#Apply Audio
	#-----------
	_on_sfx_changed(sfx_slider.value)
	_on_music_changed(music_slider.value)
	_on_ui_changed(ui_slider.value)
func _on_summary_pressed() -> void:
	SceneManager.change_scene("res://Scenes/UI/SummaryHistory.tscn")


func _on_tutorial_pressed() -> void:
	SceneManager.change_scene("res://Scenes/Levels/tutorial.tscn")
