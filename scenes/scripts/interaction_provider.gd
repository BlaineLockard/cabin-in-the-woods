class_name InteractionProvider extends RayCast3D

@export_range(0.0, 10.0, 0.01, "or_greater") var interact_range: float = 1.0:
	set(new_range):
		if new_range < 0:
			absf(new_range)
		self.target_position.z = -new_range
		interact_range = new_range

# Using process beacuse I want the input to shown to the player as soon as they press it
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		var body = get_collider()
		if body is Interactable:
			body.interact()
