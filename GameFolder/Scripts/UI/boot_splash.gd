extends Control


#===========
#ONREADY VAR
#===========
@onready var texture_rect: TextureRect = $Panel/TextureRect
@onready var texture_rect_2: TextureRect = $Panel/TextureRect2
@onready var texture_rect_3: TextureRect = $Panel/TextureRect3
@onready var label: Label = $Label
@onready var label_2: Label = $VBoxContainer/Label2
@onready var label_3: Label = $VBoxContainer/Label3

#==============
#READY FUNCTION
#==============
func _ready() -> void:
	#--------
	#Variable
	#--------
	texture_rect.modulate.a = 0.0
	texture_rect_2.modulate.a = 0.0
	texture_rect_3.modulate.a = 0.0
	
	await get_tree().process_frame
	
	var tween = create_tween()
	#--------------
	#Tween Property
	#--------------
	tween.parallel().tween_property(texture_rect_2, "modulate:a", 1.0, 2)
	tween.parallel().tween_property(texture_rect_3, "modulate:a", 1.0, 2)
	tween.parallel().tween_property(texture_rect, "modulate:a", 1.0, 2)
	tween.parallel().tween_property(label, "modulate:a", 1.0, 2)
	tween.parallel().tween_property(label_2, "modulate:a", 1.0, 2)
	tween.parallel().tween_property(label_3, "modulate:a", 1.0, 2)
	
	tween.tween_interval(1.5)
	
	tween.parallel().tween_property(texture_rect_2, "modulate:a", 0.0, 0.5)
	tween.parallel().tween_property(texture_rect_3, "modulate:a", 0.0, 0.5)
	tween.parallel().tween_property(texture_rect, "modulate:a", 0.0, 0.5)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 0.5)
	tween.parallel().tween_property(label_2, "modulate:a", 0.0, 0.5)
	tween.parallel().tween_property(label_3, "modulate:a", 0.0, 0.5)
	
	await tween.finished
	#------------
	#Function Run
	#------------
	SceneManager.change_scene("res://Scenes/UI/MainMenu.tscn")
