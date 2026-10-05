extends Node3D

const DONTLOOK_SCENE = preload("res://scenes/don't_look.tscn")
const DONTSTOP_SCENE = preload("res://scenes/don't_stop.tscn")
const DONTHEAR_SCENE = preload("res://scenes/don't_hear.tscn")
const DONTFORGET_SCENE = preload("res://scenes/don't_forget.tscn")

var standard_enemies = [DONTLOOK_SCENE, DONTSTOP_SCENE, DONTHEAR_SCENE]

var time_survived: float = 0.0
var spawn_timer: float = 5.0 # Give them 5 seconds of peace at the start
var current_base_delay: float = 20.0
const MIN_SPAWN_DELAY: float = 6.0

var darkness_triggered: bool = false


# Grab a reference to the player so we can pass it to the enemy
@export var player: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.power_on = true
	pass # Replace with function body.

func _process(delta: float) -> void:
	# 1. The Kill Switch (Power Outage)
	if Global.power_on:
		# If the power is on, reset the trap so it can fire again later
		darkness_triggered = false
	elif not darkness_triggered:
		# Power is off, and we haven't spawned the boss yet
		darkness_triggered = true
		spawn_entity(DONTFORGET_SCENE)
		return
		
	# If the power is out, halt the standard spawn loop so they only deal with the boss
	if not Global.power_on:
		return
	# if you are in the safe zone, spawning halts so they can be safe and sound
	if Global.in_safe_zone == true:
		return

	# 2. The Ramp-Up Math
	time_survived += delta
	spawn_timer -= delta
	
	# Shrink the cooldown by 1 second for every 10 seconds they survive.
	current_base_delay = max(MIN_SPAWN_DELAY, 20.0 - (time_survived / 10.0))

	# 3. Fire the Spawn
	if spawn_timer <= 0.0:
		# Add a little RNG padding to the timer so it doesn't feel like a robotic metronome
		spawn_timer = current_base_delay + randf_range(-2.0, 3.0)
		
		# pick_random() is built right into Godot arrays
		var random_scene = standard_enemies.pick_random()
		spawn_entity(random_scene)


func spawn_entity(enemy_scene):
	var new_enemy = enemy_scene.instantiate()
	add_child(new_enemy)
	
	new_enemy.spawn(player, 10.0)
	print("System spawned an entity," + new_enemy.name)

#func _input(event):
	#var new_enemy = null
	#
	#if Input.is_action_just_released("enemy_spawn1"):
		#new_enemy = DONTLOOK_SCENE.instantiate()
	#
	#if Input.is_action_just_released("enemy_spawn2"):
		#new_enemy = DONTSTOP_SCENE.instantiate()
	#
	#if Input.is_action_just_released("enemy_spawn3"):
		#new_enemy = DONTHEAR_SCENE.instantiate()
	#
	#if Input.is_action_just_released("enemy_spawn4"):
		#new_enemy = DONTFORGET_SCENE.instantiate()
	#
	#if Input.is_action_just_released("power_toggle"):
		#print("Toggling the power!")
		#Global.power_on = !Global.power_on
		#print("New state: ", Global.power_on)
	#
	#
	#if (new_enemy):
		#add_child(new_enemy)
		#new_enemy.spawn(player, 10.0)
