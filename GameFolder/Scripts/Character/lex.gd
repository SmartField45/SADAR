extends Node2D
#===============
#EXPORT VARIABLE
#===============
@export var character_name: String = "Lex"
@export var sprite_normal: Texture2D = null
@export var sprite_happy: Texture2D = null
@export var sprite_sad: Texture2D = null
@export var sprite_angry: Texture2D = null
@export var sprite_nervous: Texture2D = null
#================
#ONREADY VARIABLE
#================
@onready var sprite: Sprite2D = $Sprite2D
#======
#READY
#======
func _ready() -> void:
	#--------------
	#Connect Signal
	#--------------
	DialogBox.mood_changed.connect(_on_mood_changed)
	DialogBox.dialog_finished.connect(_on_dialog_finished)
	#-----------------
	#Default Hidden
	#-----------------
	if sprite_normal:
		sprite.texture = sprite_normal
		
	sprite.visible = false
#===========
#MOOD CHANGE
#===========
func _on_mood_changed(character: String, mood: String) -> void:
	#---------------
	#Return Function
	#---------------
	if character != character_name:
		return
	if character == "hide_all":
		sprite.visible = false
		return
	
	sprite.visible = true
	#-----------
	#Set Texture
	#-----------
	match mood:
		"Normal":   _set_texture(sprite_normal)
		"Happy":    _set_texture(sprite_happy)
		"Sad":      _set_texture(sprite_sad)
		"Angry":    _set_texture(sprite_angry)
		"Nervous":  _set_texture(sprite_nervous)
#===========
#SET TEXTURE
#===========
func _set_texture(tex: Texture2D) -> void:
	#---------------
	#Return Function
	#---------------
	if not tex:
		return
	#-----
	#Tween
	#-----
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, 0.1)
	await tween.finished
	sprite.texture = tex
	tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 1.0, 0.1)
#====
#HIDE
#====
func _on_dialog_finished() -> void:
	sprite.visible = false
