extends CanvasLayer
#================
#ONREADY VARIABLE
#================
@onready var panel: Panel = $Panel
@onready var count_label: Label = $Panel/CountLabel
@onready var evidence_list: VBoxContainer = $Panel/ScrollContainer/VBoxContainer
@onready var close_btn: TextureButton = $Panel/CloseButton
#===============
#EXPORT VARIABLE
#===============
@export var evidence_card_scene: PackedScene
#==============
#READY FUNCTION
#==============
func _ready() -> void:
	#-----------
	#Hide Panel
	#-----------
	panel.visible = false
	#---------------
	#Connect Signals
	#---------------
	GameManager.evidence_added.connect(_on_evidence_added)
	close_btn.pressed.connect(hide_panel)
#======
#INPUT
#======
func _input(event: InputEvent) -> void:
	#-----
	#Input
	#-----
	if DialogBox.panel.visible:
		return
	if not event.is_action_pressed("E"):
		return
	#-----
	#Input
	#-----
	if panel.visible:
		hide_panel()
	else:
		show_panel()
#==========
#SHOW PANEL
#==========
func show_panel() -> void:
	#-------------------
	#Visible and Refresh
	#-------------------
	panel.visible = true
	_refresh_list()
#==========
#HIDE PANEL
#==========
func hide_panel() -> void:
	#----------
	#Hide Panel
	#----------
	panel.visible = false
#============
#REFRESH LIST
#============
func _refresh_list() -> void:
	#-----------
	#Clear Cards
	#-----------
	for child in evidence_list.get_children():
		child.queue_free()
	#-----------
	#Count Label
	#-----------
	count_label.text = str(GameManager.get_evidence_count()) + " Bukti Terkumpul"
	#--------------
	#Empty Handling
	#--------------
	if GameManager.evidence.is_empty():
		return
	#---------
	#Add Cards
	#---------
	for ev in GameManager.evidence:
		_add_card(ev)
#==============
#EVIDENCE ADDED
#==============
func _on_evidence_added(ev: Dictionary) -> void:
	#-------------------
	#Update When Visible
	#-------------------
	if not panel.visible:
		return
	#---------
	#Add Card
	#---------
	_add_card(ev)
	count_label.text = str(GameManager.get_evidence_count()) + " Bukti Terkumpul"
#========
#ADD CARD
#========
func _add_card(ev: Dictionary) -> void:
	#---------------
	#Return Function
	#---------------
	if not evidence_card_scene:
		return
	#-----------
	#Instantiate
	#-----------
	var card = evidence_card_scene.instantiate()
	var icon_node = card.get_node("HBoxContainer/IconTexture")
	var name_node = card.get_node("HBoxContainer/VBoxContainer/NameLabel")
	var desc_node = card.get_node("HBoxContainer/VBoxContainer/DescLabel")
	#------------
	#Load Texture
	#------------
	var icon_path: String = ev.get("icon_path", "")
	if icon_path != "" and ResourceLoader.exists(icon_path):
		icon_node.texture = load(icon_path)
	#---------
	#Set Text
	#---------
	name_node.text = ev.get("name", "Bukti")
	desc_node.text = ev.get("desc", "")
	#---------
	#Add Child
	#---------
	evidence_list.add_child(card)
