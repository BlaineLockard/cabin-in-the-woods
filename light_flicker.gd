extends Light3D

var do_flicker
var end_off: bool

func flicker_routine(length: float, end_off: bool):
	do_flicker = true
	self.end_off = end_off
	get_tree().create_timer(length).timeout.connect(_finish_routine)
	_create_timer_between_flicker()

func _create_timer_between_flicker():
	get_tree().create_timer(randf_range(0.02, 0.35)).timeout.connect(_finish_flicker)

func _finish_flicker():
	if do_flicker:
		visible = !visible
		_create_timer_between_flicker()

func _finish_routine():
	do_flicker = false
	visible = !end_off
