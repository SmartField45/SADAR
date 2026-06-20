extends Area2D
#===============
#EXPORT VARIABLE
#===============
@export var object_id: String = "object_id"
@export var dialog_key: String = "dialog_key"
@export var already_inspected_key: String = ""
#===============
#EXPORT VARIABLE
#===============
@export var gives_evidence: bool = false
@export var evidence_id: String = ""
@export var evidence_name: String = ""
@export var evidence_desc: String = ""
@export var evidence_icon: Texture2D = null
#======
#READY
#======
func _ready() -> void:
	#---------------
	#Variable Change
	#---------------
	input_pickable = true
	#---------------
	#Connect Signals
	#---------------
	mouse_entered.connect(_on_hover_enter)
	mouse_exited.connect(_on_hover_exit)
#============
#HOVER CURSOR
#============
func _on_hover_enter() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
func _on_hover_exit() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
#===========
#INPUT EVENT
#===========
func _input_event(_viewport, event: InputEvent, _shape_idx) -> void:
	#--------
	#Variable
	#--------
	var is_mouse_click: bool = event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT
	var is_mobile_touch: bool = event is InputEventScreenTouch
	#---------------
	#Return Function
	#---------------
	if DialogBox.panel.visible:
		return
	if not (event.is_pressed() and (is_mouse_click or is_mobile_touch)):
		return
	#-----------------
	#Already Inspected
	#-----------------
	if GameManager.has_interacted(object_id):
		#-----------
		#Notif & Key
		#-----------
		NotificationSystem.show_notif("Sudah diperiksa.")
		if already_inspected_key != "":
			DialogBox.start(already_inspected_key)
		return
	#--------------------
	#Mark and Start Dialog
	#--------------------
	GameManager.mark_interacted(object_id)
	DialogBox.start(dialog_key)
	#---------------
	#Return Function
	#---------------
	if not gives_evidence:
		return
	#-----------
	#Wait Dialog
	#-----------
	await DialogBox.dialog_finished
	#------------------
	#Evidence Duplicate
	#------------------
	if GameManager.has_evidence(evidence_id):
		NotificationSystem.show_notif("Bukti sudah ada di folder.")
		return
	#-----------
	#Add Evidence
	#-----------
	var icon_path: String = evidence_icon.resource_path if evidence_icon else ""
	GameManager.add_evidence({
		"id": evidence_id,
		"name": evidence_name,
		"desc": evidence_desc,
		"icon_path": icon_path,
	})
