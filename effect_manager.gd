class_name EffectManager extends Node3D

## The cutoff Hz for sounds when muffled. Lower = more muffled
@export var muffle_cutoff_hz: float = 800.0
## How far the player can see when blinded
@export var blinded_vision_range: float = 15.0
## How fast the player will move when movement hindered[br]For reference, base walk speed is [b]5.0
@export var limp_move_speed = 2.5

const BASE_EFFECT_LENGTH: float = 15.0

var player: CharacterController

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if !player:
		push_warning(name, " could not find the player, the game will likely not run properly")

func effect_player(enemy_name: String):
	# Lower and strip just to make it easier
	enemy_name = enemy_name.to_lower().strip_edges()
	match enemy_name:
		"don'tlook":
			blind_player(BASE_EFFECT_LENGTH)
		"don'tstop":
			limp_player(BASE_EFFECT_LENGTH)
		"theonethatwillbebasedoffofaudiopleasechangethistoitsactualnamewhen/ifwemakeitcuzimnotgoodatnamingthings":
			muffle_audio(BASE_EFFECT_LENGTH)
		_:
			push_error("\"", enemy_name, "\" attacked player with no effect to give.")

## Limit vision of player with a fog. 
func blind_player(time: float):
	pass

## Break the players leg
func limp_player(time: float):
	player.limp_speed = limp_move_speed
	player.should_limp = true
	
	await get_tree().create_timer(time).timeout
	
	player.should_limp = false

func muffle_audio(time: float):
	var bus_idx = AudioServer.get_bus_index("Master")
	var filter = AudioServer.get_bus_effect(bus_idx, 0) as AudioEffectLowPassFilter
	
	filter.cutoff_hz = 800.0
	await get_tree().create_timer(time).timeout
	filter.cutoff_hz = 20500.0
