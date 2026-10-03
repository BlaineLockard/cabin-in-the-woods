class_name GameEndManager extends Node3D

# I want the effect manager to be my child, if it's not, I can still get it, but it's less effecient
@onready var effect_manager: EffectManager = $EffectManager

@export var allowed_hits: = 2

var player: CharacterController

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if !player:
		push_warning(name, " could not find the player, the game will likely not run properly")
	call_deferred("_verify_effect_manager")

func _verify_effect_manager():
	if effect_manager:
		# I got my son, I am happy
		return
	# I must find my boy
	for child in get_tree().current_scene.get_children(true):
		if child is EffectManager:
			effect_manager = child
			return
	# I could not find mi hijo :(
	push_warning(name, " could not find an Effect Manager in scene. Enemies will not effect players gameplay")

func connect_to_enemy(enemy: BaseEnemy):
	enemy.hurt_player.connect(hurt_player)

func hurt_player(enemy: String):
	allowed_hits -= 1
	if allowed_hits == 0:
		# Just restart the game for now. I will work on the fancy stuff if I have time
		Global.fatal_OS_error(Global.system_name, "Found you :)")
	# Effect player if we have an effect manager
	if effect_manager:
		effect_manager.effect_player(enemy)
