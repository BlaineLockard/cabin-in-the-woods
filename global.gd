extends Node

#note: this is in db. 0.0 db is the default volume amount.
var current_player_volume: float = 0.0

var system_name: String = "Player"

func _ready():
	if OS.has_environment("USERNAME"):
		system_name = OS.get_environment("USERNAME")
	elif OS.has_environment("USER"): # macOS/Linux
		system_name = OS.get_environment("USER")

func safe_OS_message(message: String, header: String):
	print("SENDING OS ALERT: " + message)
	get_tree().paused = true
	
	# 2. Free the mouse so the player can actually click "OK"
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	await get_tree().create_timer(0.1).timeout
	
	OS.alert(message, header)
	
	# 5. Recapture the mouse and unpause
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false


func fatal_OS_error(message: String, header: String):
	# Free the mouse so they can click OK
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	await get_tree().create_timer(0.1).timeout
	
	# Show the alert. The thread freezes until they click it.
	await safe_OS_message(message, header)
	
	# Instantly kill the game the moment they close the popup
	OS.crash("Fatal error")
