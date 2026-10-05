extends BaseEnemy
class_name DontStop

const PLAYER_RUN_TIME = 1.0

@onready var run_sound: AudioStreamPlayer = $ChaseSound
var total_run_time: float = 0.0

var delayed_y_rotation: float = 0.0

func _on_spawn():
	#TODO: this is where the logic would go to make a UI message
	#push UI message to stay where they are
	#await call_OS_alert("Stay where you are.")
	
	run_sound.volume_db = -40.0
	run_sound.play()
	
	#go 100m into the ground so we no see
	global_position.y = -100.0


func attack_loop(_delta: float):
	
	#play the sound of running and slowly increase the volume as the duration goes on
	var time_ratio = _time_alive / active_time
	run_sound.volume_db = lerp(-40.0, 10.0, time_ratio)
	
	#if the player ever presses run for a few seconds, they survive
	if Input.is_action_pressed("sprint"):
		total_run_time += _delta
		
		if total_run_time > PLAYER_RUN_TIME:
			survive()
	else:
		total_run_time = 0.0
	
	super.attack_loop(_delta)

#What do we do when the player successfully survives the enemy's encounter?
func survive():
	is_active = false
	print("Player survived " + str(name) + "'s encounter.")
	
	var fade_tween = create_tween()
	fade_tween.tween_property(run_sound, "volume_db", -40.0, 1.5)
	await fade_tween.finished
	
	despawn()

func despawn():
	queue_free()

func _physics_process(delta: float) -> void:
	if not is_active:
		return
	
	_time_alive += delta
	
	#Time alive COUNTS UP to the time we specify that the enemy is active. Once it matches, UNLIKE OTHER ENEMIES, the player will be attacked..
	if _time_alive >= active_time:
		attack()
	else:
		#until then, shenanigans
		attack_loop(delta)
