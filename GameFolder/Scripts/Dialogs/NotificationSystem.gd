extends CanvasLayer

#================
#ONREADY VARIABLE
#================
@onready var panel = $Panel
@onready var notif_label = $Panel/NotifLabel
#======
#READY
#======
func _ready() -> void:
	#-----------
	#Hide Panel
	#-----------
	panel.modulate = Color.WHITE
	panel.visible = false
#===========
#SHOW NOTIF
#===========
func show_notif(message: String) -> void:
	#-----------
	#Set Message
	#-----------
	notif_label.text = message
	panel.visible = true
	panel.modulate = Color.WHITE
	#-----------
	#Auto Hide
	#-----------
	_auto_hide()
#=========
#AUTO HIDE
#=========
func _auto_hide() -> void:
	#-----------
	#Wait Timer
	#-----------
	await get_tree().create_timer(1.8).timeout
	#-----------
	#Fade Tween
	#-----------
	var tween = create_tween()
	tween.tween_property(panel, "modulate:a", 0.0, 0.4)
	await tween.finished
	#------
	#Reset
	#------
	panel.visible = false
	panel.modulate = Color.WHITE
