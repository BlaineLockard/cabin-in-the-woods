class_name SwitchManager extends Node3D


@export_range(0, 99999, 1, "suffix:seconds", "hide_slider") var allowed_lightless_time: float = 5:
	set(time):
		allowed_lightless_time = time
		await ready
		death_time.wait_time = time
@export var switches: Array[Switch]
@export var light: Light3D


@onready var death_time: Timer = $TimeToDeath


var on_switches: Array[Switch]


func _ready() -> void:
	on_switches = switches.duplicate(true)
	call_deferred("_set_ids")
	call_deferred("_connect_function")

func _set_ids():
	# Set each switch ID to it's index
	for i in range(switches.size()):
		switches[i].switch_id = i

func _connect_function():
	for switch in switches:
		switch.switch_triggered.connect(_switch_triggered)


func _switch_triggered(id: int):
	print("Turn on ", switches[id].name)
	on_switches.append(switches[id])
	light.visible = true
	death_time.paused = true


# Assumes there is a switch to flip
func turn_off_random_switch():
	var switch_to_flip: Switch = on_switches.pick_random()
	switch_to_flip.is_on = false
	print("Turned off ", switch_to_flip.name)
	on_switches.erase(switch_to_flip)
	
	if on_switches.size() == 0:
		light.visible = false
		death_time.start()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("enemy_spawn1"):
		turn_off_random_switch()


func _on_time_to_death_timeout() -> void:
	print("die die die")
