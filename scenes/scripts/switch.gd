class_name Switch extends Interactable

signal switch_triggered(id: int)

var switch_id: int

var is_on: bool = true:
	set(new_state):
		is_on = new_state
		if is_on:
			_trigger_switch_on()
		else:
			_trigger_switch_off()

func interact():
	if !is_on:
		is_on = true
		switch_triggered.emit(switch_id)
		print("Hi, my name is switch. My background consists of... Interactable and CollisionShape. The more you interact with me and read me, the less work gets done and the game wont be finished.")

# The switch is in on state, no animation, no sound, keep lights on
func _trigger_switch_on():
	pass
	# stop nimations and sound

# The switch is in off state, no animation, no sound, closer to lights off
func _trigger_switch_off():
	pass
	# play animations and sound
