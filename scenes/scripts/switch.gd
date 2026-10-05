class_name Switch extends Interactable

const GREEN: Color = Color("005f00")
const RED: Color = Color("5f0000")

signal switch_triggered(id: int)

@onready var connected_light: OmniLight3D = $MeshInstance3D3/SpotLight3D

var mat: StandardMaterial3D
var switch_id: int

var is_on: bool = true:
	set(new_state):
		is_on = new_state
		if is_on:
			_trigger_switch_on()
		else:
			_trigger_switch_off()

func _ready() -> void:
	mat = $MeshInstance3D3.get_active_material(0).duplicate()
	$MeshInstance3D3.set_surface_override_material(0, mat)
	mat.albedo_color = GREEN
	mat.emission = GREEN
	connected_light.light_color = GREEN

func interact():
	if !is_on:
		is_on = true
		switch_triggered.emit(switch_id)

# The switch is in on state, no animation, no sound, keep lights on
func _trigger_switch_on():
	mat.albedo_color = GREEN
	mat.emission = GREEN
	connected_light.light_color = GREEN

# The switch is in off state, no animation, no sound, closer to lights off
func _trigger_switch_off():
	mat.albedo_color = RED
	mat.emission = RED
	connected_light.light_color = RED
