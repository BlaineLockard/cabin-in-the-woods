extends Node3D

# Drag your specific enemy scene (e.g., DontLook.tscn) into this slot in the Inspector
const ENEMY_SCENE = preload("res://assets/enemy_base.tscn")

# Grab a reference to the player so we can pass it to the enemy
@export var player: Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	# Press 'K' to spawn the monster
	if event is InputEventKey and event.pressed and event.keycode == KEY_K:
		var new_enemy = ENEMY_SCENE.instantiate()
		
		# Always add to the scene tree BEFORE calling custom setup logic
		add_child(new_enemy)
		
		# Pass the player node and set the active time to 10 seconds
		new_enemy.spawn(player, 10.0)
