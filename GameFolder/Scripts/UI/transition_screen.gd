extends CanvasLayer
#======
#SIGNAL
#======
signal transition_finished
#=================
#ONREADY VARIABLES
#=================
@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer
#==============
#READY FUNCTION
#==============
func _ready() -> void:
	#---------------------------
	#Variables, Animation Manage
	#---------------------------
	color_rect.visible = false
	animation_player.animation_finished.connect(on_animation_finished)

#==================
#ANIMATION FINISHED
#==================
func on_animation_finished(animation_name: String) -> void:
	#----------------
	#Animation Manage
	#-----------------
	if animation_name == "fade_in":
		transition_finished.emit()                                      #If fade_in finished: Screen is fully covered, safe moment to change scene
	elif animation_name == "fade_out":
		color_rect.visible = false                                      #If fade_out finished:Screen becomes visible again, hide the overlay

#========================
#TRANSITION FADE IN/OUT
#=========================
func fade_in() -> void:
	#-------------------------
	#Variables, Animation Play
	#-------------------------
	color_rect.visible = true
	animation_player.play("fade_in")

func fade_out() -> void:
	#------------------------
	#Variable, Animation Play
	#------------------------
	animation_player.play("fade_out")
