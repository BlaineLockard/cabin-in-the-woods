extends CharacterBody3D
class_name BaseEnemy

var active_time: float = 5.0
var _time_alive: float = 0.0
var is_active: bool = false
var player: Node3D = null

#we're evil. These store what we want to show during a jumpscare.
@export var scare_image: Texture2D
@export var scare_sfx: AudioStream

func spawn(target: Node3D, duration: float):
	player = target
	active_time = duration
	_time_alive = 0.0
	is_active = true
	
	#Call the function that defines what this enemy does when they spawn in
	_on_spawn()

#surprise tools to help us later
func _on_spawn():
	pass

#What will this enemy constantly do, that the player has to 
#deal with or manage? Goes into here.
func attack_loop(_delta: float):
	
	if Input.is_key_pressed(KEY_J):
		print("attacking!")
		attack()
	
	pass

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

# NOTE: Only connects properly if I am in the enemies group!
# I dont need to connect anything! I just need to have the correct function name and be in the Enemy group!
func react_to_weapon(_postion: Vector3):
	##Override this function to make the enemy react to gunshots.
	pass

func _physics_process(delta: float) -> void:
	if not is_active:
		return
	
	#Would apply gravity. Commented out for now, as all enemies dono't need gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
	#
	#velocity.x = move_toward(velocity.x, 0, SPEED)
	#velocity.z = move_toward(velocity.z, 0, SPEED)
	
	_time_alive += delta
	
	#Time alive COUNTS UP to the time we specify that the enemy is active. Once it matches, the player survives.
	if _time_alive >= active_time:
		survive()
	else:
		#until then, shenanigans
		attack_loop(delta)
