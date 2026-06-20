extends CanvasLayer
#======
#SIGNAL
#======
signal dialog_finished
signal mood_changed(character: String, mood: String)
#================
#ONREADY VARIABLE
#================
@onready var panel      = $Panel
@onready var name_label = $Panel/NameLabel
@onready var text_label = $Panel/TextLabel
#===============
#EXPORT VARIABLE
#===============
@export var text_speed: float = 0.03
#========
#VARIABLE
#========
var data: Dictionary = {}
var current_key: String = ""
var is_typing: bool = false
var full_text: String = ""
#==============
#READY FUNCTION
#==============
func _ready() -> void:
	panel.visible = false
#=========
#LOAD JSON
#=========
func load_chapter(path: String) -> void:
	#--------
	#Variable
	#--------
	var file = FileAccess.open(path, FileAccess.READ)
	#---------------
	#Return Function
	#---------------
	if file == null:
		push_error("File tidak ditemukan: " + path)
		return
	#--------
	#Variable
	#--------
	var json = JSON.new()
	var err  = json.parse(file.get_as_text())
	#---------------
	#Return Function
	#---------------
	if err != OK:
		push_error("JSON error baris %d: %s" % [json.get_error_line(), json.get_error_message()])
		return
	#----------
	#Close File
	#----------
	file.close()
	#--------
	#Get Data
	#--------
	data = json.get_data()
#==========
#START GAME
#==========
func start(from_key: String = "Start") -> void:
	panel.visible = true
	get_tree().paused = false
	_go_to(from_key)
#============
#CONTINUE KEY
#============
func _go_to(key: String) -> void:
	#---------------
	#Return Function
	#---------------
	if not data.has(key):
		push_error("Key tidak ada di JSON: " + key)
		_end()
		return
	#---------------------------
	#Variable Declare and Change
	#---------------------------
	current_key = key
	var node = data[key]
	var speaker: String = node.get("Name", "")
	var mood: String = node.get("Mood", "Normal")
 	#----------
	#Name Label
	#----------
	name_label.visible = (speaker != "" and speaker != "...")
	#---------
	#Text Edit
	#---------
	if name_label.visible:
		name_label.text = speaker
	if speaker != "" and speaker != "...":
		emit_signal("mood_changed", speaker, mood)
	else:
		emit_signal("mood_changed", "hide_all", "")
	#-----
	#Match 
	#-----
	match node.get("JusticeMeter", ""):
		"Increase": GameManager.change_justice(+10)
		"Decrease": GameManager.change_justice(-10)
	#--------
	#Get Node
	#--------
	full_text = node.get("Text", "")
	#---------------
	#Variable Change
	#---------------
	is_typing = true
	#---------------------------
	#Reset Text and Function Run
	#---------------------------
	text_label.text = ""
	_type_text()
#==========
#TYPEWRITER
#==========
func _type_text() -> void:
	#--------
	#For Loop
	#--------
	for i in full_text.length():
		#--------------
		#Break Function
		#--------------
		if not is_typing:
			break
		#----
		#Type
		#----
		text_label.text = full_text.substr(0, i + 1)
		await get_tree().create_timer(text_speed).timeout
	#---------------
	#Variable Change
	#---------------
	text_label.text = full_text
	is_typing = false
	#--------
	#Variable
	#--------
	var node = data[current_key]
	#------------------
	#Instantiate Choice
	#------------------
	if node.has("Choices"):
		_show_choices(node["Choices"])
#==============
#INPUT FUNCTION
#==============
func _input(event: InputEvent) -> void:
	#---------------
	#Return Function
	#---------------
	if not panel.visible or not event.is_action_pressed("Space"):
		return
	#--------
	#Variable
	#--------
	var node = data.get(current_key, {})
	#----
	#Skip
	#----
	if is_typing:
		is_typing = false
		text_label.text = full_text
		#~~~~~~~~~~~~~~~~~~~
		#Instantiate Choices
		#~~~~~~~~~~~~~~~~~~~
		if node.has("Choices"):
			_show_choices(node["Choices"])
		return
 	#---------------
	#Return Function
	#---------------
	if node.has("Choices"):
		return
	#---------
	#Next Text
	#---------
	if node.has("Next"):
		_go_to(node["Next"])
	else:
		_end()
#============
#SHOW CHOICES
#============
func _show_choices(choices: Dictionary) -> void:
	#-----------------
	#Autoload Function
	#-----------------
	ChoicesBox.show_choices(
		choices, 
		func(next_key: String) -> void:
		ChoicesBox.hide_choices()
		_go_to(next_key)
	)
#==========
#END DIALOG
#==========
func _end() -> void:
	panel.visible = false
	emit_signal("dialog_finished")


func _on_next_pressed() -> void:
	if not panel.visible:
		return
		
	#--------
	#Variable
	#--------
	var node = data.get(current_key, {})
	#----
	#Skip
	#----
	if is_typing:
		is_typing = false
		text_label.text = full_text
		#~~~~~~~~~~~~~~~~~~~
		#Instantiate Choices
		#~~~~~~~~~~~~~~~~~~~
		if node.has("Choices"):
			_show_choices(node["Choices"])
		return
 	#---------------
	#Return Function
	#---------------
	if node.has("Choices"):
		return
	#---------
	#Next Text
	#---------
	if node.has("Next"):
		_go_to(node["Next"])
	else:
		_end()
