class_name SwitchManager extends Node3D


@export_range(1, 99999, 1, "suffix:seconds", "hide_slider") var allowed_lightless_time: float = 5:
	set(time):
		allowed_lightless_time = time
		await ready
		death_time.wait_time = time
@export_range(1, 99999, 1, "suffix:seconds", "hide_slider") var initial_time_between_switch_flips: float = 35:
	set(time):
		initial_time_between_switch_flips = time
@export_range(0, 99999, 1, "suffix:%", "hide_slider") var difficulty_increase_after_flip: float = 10:
	set(value):
		difficulty_increase_after_flip = value
@export var switches: Array[Switch]
@export var light: Light3D


@onready var death_time: Timer = $TimeToDeath
@onready var flip_switch_timer: Timer = $flip_switch_timer


var on_switches: Array[Switch]
var time_between_next_flip: float
var difficulty_increase: float

func _ready() -> void:
	on_switches = switches.duplicate(true)
	time_between_next_flip = initial_time_between_switch_flips
	difficulty_increase = difficulty_increase_after_flip/100
	flip_switch_timer.wait_time = 10
	flip_switch_timer.start()
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
	on_switches.append(switches[id])
	light.flicker_routine(1, false)
	death_time.paused = true

	

func turn_off_random_switch():
	if on_switches.size() == 0:
		return
	var switch_to_flip: Switch = on_switches.pick_random()
	switch_to_flip.is_on = false
	on_switches.erase(switch_to_flip)
	
	if on_switches.size() == 0:
		light.flicker_routine(1, true)
		death_time.start()
	else:
		light.flicker_routine(1, false)

func _on_time_to_death_timeout() -> void:
	Global.power_on = false


func _on_flip_switch_timer_timeout() -> void:
	turn_off_random_switch()
	flip_switch_timer.wait_time = time_between_next_flip
	flip_switch_timer.start()
	time_between_next_flip *= (1 - difficulty_increase)
