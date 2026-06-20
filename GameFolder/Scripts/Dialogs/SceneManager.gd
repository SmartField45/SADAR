extends Node
#=================
#ONREADY VARIABLES
#=================
@onready var transition = preload("res://Scenes/UI/TransitionScreen.tscn").instantiate()
#=========
#VARIABLES
#=========
var is_transitioning = false
var slugline_data: Dictionary = {}

#==============
#READY FUNCTION
#==============
func _ready() -> void:
	#--------------------
	#Function Load, Child
	#--------------------
	add_child(transition)
	
#==================
#TRANSITION MANAGER
#==================
func change_scene(path: String) -> void:
	#---------------
	#Return Function
	#---------------
	if is_transitioning:
		return
	#---------
	#Variables
	#---------
	is_transitioning = true
	#-----------------
	#GUI, Change Scene
	#-----------------
	transition.fade_in()
	await transition.transition_finished
	#-----------------------------
	#Get Tree, Scene Path, Fade In
	#-----------------------------
	get_tree().change_scene_to_file(path)
	await get_tree().process_frame
	#---------------------------
	#GUI, Change Scene, Fade Out
	#---------------------------
	transition.fade_out()
	is_transitioning = false
#===============
#SLUGLINE SYSTEM
#===============
func show_slugline(chapter: String, title: String, next_scene: String) -> void:
	#-------------------
	#SlugLine Dictionary
	#-------------------
	slugline_data = {
		"chapter": chapter, 
		"title": title, 
		"next_scene": next_scene
		}
	#------------
	#Function Run
	#------------
	change_scene("res://Scenes/UI/Slugline.tscn")
#=================
#Get Slugline Data
#=================
func get_slugline_data() -> Dictionary:
	return slugline_data
