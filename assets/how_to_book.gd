extends Node3D

@onready var canvasLayer = $CanvasLayer
@onready var close_button = $CanvasLayer/Panel/Close

@onready var detection_zone: Area3D = $Area3D

@export var player: CharacterController

var open: bool = false
var player_in_range: bool = false

func _ready() -> void:
	# Hide it on boot just in case you left it visible in the editor
	canvasLayer.hide()
	
	# Hook up the signals completely via code
	close_button.pressed.connect(_on_close_pressed)
	detection_zone.body_entered.connect(_on_body_entered)
	detection_zone.body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	# Change "interact" to whatever your 'E' key is called in the Input Map
	if player_in_range and Input.is_action_just_pressed("interact") and not open:
		open_tutorial()

func open_tutorial() -> void:
	open = true
	canvasLayer.show()
	
	# Free the mouse so they can click the close button
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Optional: Freeze the game while they read
	get_tree().paused = true 

func _on_close_pressed() -> void:
	open = false
	canvasLayer.hide()
	
	# Trap the mouse again so they can play
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Optional: Unfreeze the game
	get_tree().paused = false

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		
		if open:
			_on_close_pressed()
