extends BaseEnemy
class_name DontLook

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var HOVER_DELAY_FACTOR: float = 6.0
@export var FORCED_ROTATE_FACTOR: float = 2.0
@export var hover_dist = 6.0
@export var height_offset = 0.5

var delayed_y_rotation: float = 0.0

func _on_spawn():
	#TODO: this is where the logic would go to make a UI message to use the
	#mouse to look behind them
	
	delayed_y_rotation = player.global_rotation.y


func attack_loop(_delta: float):
	
	#TODO: go directly behind the player, close behind them, hovering to rotate and follow their view 
	#with a two second delay. if we've been active for more than five seconds, forcibly apply 
	#rotation to make them look behind them
	delayed_y_rotation = lerp_angle(delayed_y_rotation, player.global_rotation.y, _delta* (1.0 / HOVER_DELAY_FACTOR))
	
	var offset = Vector3.BACK.rotated(Vector3.UP, delayed_y_rotation) * hover_dist
	global_position = player.global_position + Vector3(0, height_offset, 0) + offset
	var dir_to_enemy = player.global_position.direction_to(global_position)
	var player_forward = -player.global_transform.basis.z
	var player_right = player.global_transform.basis.x
	
	if _time_alive > 5.0:
		var turn_dir = -sign(player_right.dot(dir_to_enemy))
		if turn_dir == 0:
			turn_dir = 1.0
			
		player.rotate_y(FORCED_ROTATE_FACTOR * _delta * turn_dir)
	
	if player_forward.dot(dir_to_enemy) > 0.8:
		attack()

#How do we snatch the player's chain?
func attack():
	is_active = false
	print(str(name) + " triggered! Applying jumpscare and penalty...")
	player.get_node("JumpscareManager").trigger_scare(scare_image, scare_sfx)
	
	despawn()

#What do we do when the player successfully survives the enemy's encounter?
func survive():
	is_active = false
	print("Player survived " + str(name) + "'s encounter.")
	despawn()

func despawn():
	queue_free()
