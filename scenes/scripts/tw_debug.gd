extends Node3D

const ENEMY_SCENE = preload("res://scenes/enemy_base.tscn")
const DONTLOOK_SCENE = preload("res://scenes/don't_look.tscn")
const DONTSTOP_SCENE = preload("res://scenes/don't_stop.tscn")

# Grab a reference to the player so we can pass it to the enemy
@export var player: Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	var new_enemy = null
	
	if Input.is_action_just_released("enemy_spawn1"):
		new_enemy = DONTLOOK_SCENE.instantiate()
	
	if Input.is_action_just_released("enemy_spawn2"):
		new_enemy = DONTSTOP_SCENE.instantiate()
	
	if (new_enemy):
		
		add_child(new_enemy)
		new_enemy.spawn(player, 10.0)
