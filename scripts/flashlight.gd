class_name Flashlight extends Node3D


@export var light_range: float = 20.0
@export var light_energy: float = 3.0

@onready var light_source: SpotLight3D = $lightSource


func _ready() -> void:
	light_source.spot_range = light_range
	light_source.light_energy = light_energy
	#Move light to center of camera
	light_source.global_position = get_parent().global_position


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("light"):
		light_source.visible = !light_source.visible
