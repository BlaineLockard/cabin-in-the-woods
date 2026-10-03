extends Node

#note: this is in db. 0.0 db is the default volume amount.
var current_player_volume: float = 0.0

var system_name: String = "Player"

func _ready():
	if OS.has_environment("USERNAME"):
		system_name = OS.get_environment("USERNAME")
	elif OS.has_environment("USER"): # macOS/Linux
		system_name = OS.get_environment("USER")
