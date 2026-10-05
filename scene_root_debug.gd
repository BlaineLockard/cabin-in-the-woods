extends Node3D

const DONTLOOK_SCENE = preload("res://scenes/don't_look.tscn")
const DONTSTOP_SCENE = preload("res://scenes/don't_stop.tscn")
const DONTHEAR_SCENE = preload("res://scenes/don't_hear.tscn")
const DONTFORGET_SCENE = preload("res://scenes/don't_forget.tscn")


# Grab a reference to the player so we can pass it to the enemy
@export var player: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input(event):
	var new_enemy = null
	
	if Input.is_action_just_released("enemy_spawn1"):
		new_enemy = DONTLOOK_SCENE.instantiate()
	
	if Input.is_action_just_released("enemy_spawn2"):
		new_enemy = DONTSTOP_SCENE.instantiate()
	
	if Input.is_action_just_released("enemy_spawn3"):
		new_enemy = DONTHEAR_SCENE.instantiate()
	
	if Input.is_action_just_released("enemy_spawn4"):
		new_enemy = DONTFORGET_SCENE.instantiate()
	
	if Input.is_action_just_released("power_toggle"):
		print("Toggling the power!")
		Global.power_on = !Global.power_on
		print("New state: ", Global.power_on)
	
	if (new_enemy):
		add_child(new_enemy)
		new_enemy.spawn(player, 10.0)
