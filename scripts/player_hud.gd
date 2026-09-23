class_name HUD extends CanvasLayer

@onready var crosshair = $Crosshair

var player: CharacterController

var Components = {}

func _ready() -> void:
	for child in get_children():
		Components[child.name.to_lower()] = child

func _process(_delta: float) -> void:
	pass


##Changes the modulate variable of a component
func colorComponent(name: String, color: Color):
	Components[name].modulate = color

##Disables visiblity of a component
func hideComponent(name: String):
	Components[name].visible = false
	
##Enables visiblity of a component
func showComponent(name: String):
	Components[name].visible = true
