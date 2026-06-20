extends Node

#======
#SIGNAL 
#======
signal justice_changed(new_value: int)
signal evidence_added(evidence_data: Dictionary)
#========
#VARIABLE
#========
var justice_meter: int = 50 #Max Value = 100
var evidence: Array = []
var collected_ids: Array = []

var current_chapter: int = 1
var current_part: int    = 1
var visited_scenes: Array = []

var interacted_objects: Array = []
var completed_levels: Array = []
#=====
#CONST
#=====
const SAVE_PATH = "user://savegame.cfg"

#===================
#SET, CHANGE JUSTICE
#===================
func set_justice(new_val: int) -> void:
	#---------
	#Value Set
	#---------
	justice_meter = clamp(new_val, 0, 100)
	#-----------
	#Emit Signal
	#-----------
	emit_signal("justice_changed", justice_meter)
func change_justice(amount: int) -> void:
	set_justice(justice_meter + amount)
#==============================
#ADD, CHECK, AND COUNT EVIDENCE
#==============================
func add_evidence(data: Dictionary) -> void:
	#---------------
	#Return Function
	#---------------
	if collected_ids.has(data["id"]):
		return
	#------
	#Append
	#------
	evidence.append(data)
	collected_ids.append(data["id"])
	#-----------
	#Emit Signal
	#-----------
	emit_signal("evidence_added", data)
#==================
#Return Size and ID
#==================
func has_evidence(id: String) -> bool:
	return collected_ids.has(id)
func get_evidence_count() -> int:
	return evidence.size()
#=========================
#MARK, CHECK VISITED SCENE
#=========================
func mark_scene_visited(scene_name: String) -> void:
	#--------------------
	#Append Visited Scene
	#--------------------
	if not visited_scenes.has(scene_name):
		visited_scenes.append(scene_name)
func has_visited(scene_name: String) -> bool:
	return visited_scenes.has(scene_name)
#=============================
#ADD, CHECK INTERACTED OBJECTS
#=============================
func mark_interacted(object_id: String) -> void:
	#-----------------
	#Append Interacted
	#-----------------
	if not interacted_objects.has(object_id):
		interacted_objects.append(object_id)
func has_interacted(object_id: String) -> bool:
	return interacted_objects.has(object_id)
#=========================
#SAVE, LOAD AND RESET GAME
#=========================
func save_game() -> void:
	#--------
	#Variable
	#--------
	var config = ConfigFile.new()
	#----------------
	#Config Set Value
	#----------------
	config.set_value("game", "justice_meter", justice_meter)
	config.set_value("game", "evidence", evidence)
	config.set_value("game", "collected_ids", collected_ids)
	config.set_value("game", "current_chapter", current_chapter)
	config.set_value("game", "current_part", current_part)
	config.set_value("game", "visited_scenes", visited_scenes)
	config.set_value("game", "interacted_objects", interacted_objects)
	config.set_value("game", "completed_levels", completed_levels)
	config.save(SAVE_PATH)
func load_game() -> void:
	#--------
	#Variable
	#--------
	var config = ConfigFile.new()
	#---------------
	#Return Function
	#---------------
	if config.load(SAVE_PATH) != OK:
		return
	#----------
	#Load Value
	#----------
	justice_meter = config.get_value("game", "justice_meter", 50)
	evidence = config.get_value("game", "evidence", [])
	collected_ids = config.get_value("game", "collected_ids", [])
	current_chapter = config.get_value("game", "current_chapter", 1)
	current_part = config.get_value("game", "current_part", 1)
	visited_scenes = config.get_value("game", "visited_scenes", [])
	interacted_objects = config.get_value("game", "interacted_objects", [])
	completed_levels = config.get_value("game", "completed_levels", [])
	#-----------
	#Emit Signal
	#-----------
	emit_signal("justice_changed", justice_meter)
func reset_game() -> void:
	#----------
	#Set Value
	#----------
	justice_meter = 50
	evidence = []
	collected_ids = []
	current_chapter = 1
	current_part = 1
	visited_scenes = []
	interacted_objects = []
	completed_levels = []

	#--------
	#Variable
	#--------
	var dir = DirAccess.open("user://")
	#-----------
	#Remove File
	#-----------
	if dir and dir.file_exists("savegame.cfg"):
		dir.remove("savegame.cfg")
