extends CanvasLayer

#================
#ONREADY VARIABLE
#================
@onready var vbox: VBoxContainer = $Panel/VBoxContainer
@onready var buttons = [
	$Panel/VBoxContainer/Button, 
	$Panel/VBoxContainer/Button2, 
	$Panel/VBoxContainer/Button3
	]
#========
#VARIABLE
#========
var _callback: Callable

#==============
#READY FUNCTION
#==============
func _ready() -> void:
	visible = false
#============
#SHOW CHOICES
#============
func show_choices(choices: Dictionary, callback: Callable) -> void:
	#---------------
	#Variable Change
	#---------------
	_callback = callback
	visible = true
 	#--------
	#Variable
	#--------
	var labels = choices.keys()    #teks tombol
	var targets = choices.values() #key tujuan
 	#--------
	#For Loop
	#--------
	for i in buttons.size():
		#--------------------------
		#Labels and Button Modulate
		#--------------------------
		if i < labels.size():
			buttons[i].text    = labels[i]
			buttons[i].visible = true
 			
			var target_key = targets[i]
			#----------------
			#Reset Connection
			#----------------
			if buttons[i].pressed.is_connected(_on_choice_pressed.bind(target_key)):
				buttons[i].pressed.disconnect(_on_choice_pressed.bind(target_key))
			buttons[i].pressed.connect(_on_choice_pressed.bind(target_key), CONNECT_ONE_SHOT)
		else:
			buttons[i].visible = false
#============
#HIDE CHOICES
#============
func hide_choices() -> void:
	#---------------
	#Variable Change
	#---------------
	visible = false
	#-------------
	#Reset Buttons
	#-------------
	for btn in buttons:
		btn.visible = false
#--------------
#Choice Pressed
#--------------
func _on_choice_pressed(next_key: String) -> void:
	_callback.call(next_key)
