extends Node3D

signal weapon_fired(position: Vector3)

## How much ammo the gun will carry in a magazine. [br]Set to negative number to remove reloading.
@export var max_ammo: int = 17

var ammo_count: int = max_ammo


func _ready() -> void:
	# Add one more bullet in the chamber
	ammo_count += 1
	
	for enemy in get_tree().get_nodes_in_group("enemies"):
		connect("weapon_fired", enemy.react_to_weapon)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED: # If the mouse is captured and clicked
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed(): # If the mouse click the left click and is pressed
			get_viewport().set_input_as_handled()
			shoot()


func shoot():
	# Do not want to shoot if they dont have ammo
	if ammo_count == 0:
		reload()
		return
	ammo_count -= 1
	weapon_fired.emit(global_position)
	# Play animations
	# Play sound
	print(ammo_count, " bullets remaing")


func reload():
	# Play animation
	# Play sounds
	# TODO: MAKE SURE TO USE AWAIT TO WAIT UNTIL AFTER THE ANIMATION FINISHES BEFORE CHANGING AMMO COUNT
	# Likely will want to move actual changing of the ammo into different function to be called at end of animation
	if ammo_count == 0:
		ammo_count = max_ammo
	else:
		ammo_count = max_ammo + 1 
	print("reloaded gun with ", ammo_count, " bullets")
