extends CanvasLayer


func _ready() -> void:
	visible = false
	get_tree().paused = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()

func _on_resume_pressed() -> void:
	toggle_pause()

func toggle_pause():
	if get_tree().paused:
		# Unpause and trap the mouse
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		visible = false
		get_tree().paused = false
	else:
		# Pause and free the mouse
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		visible = true
		get_tree().paused = true

func _on_quit_pressed() -> void:
	print("Quitting the game!")
	get_tree().quit()


func _on_audio_control_value_changed(value: float) -> void:
	pass # Replace with function body.
