extends BaseEnemy
class_name DontForget

@onready var voice_sound: AudioStreamPlayer = $VoiceSound


func _on_spawn():
	#TODO: this is where the logic would go to make a UI message
	#push UI message to stay where they are
	await call_OS_alert("Pause the game and increase your volume to hear game sounds! :D")
	
	voice_sound.volume_db = -40.0
	voice_sound.play()
	
	#go 100m into the ground so we no see
	global_position.y = -100.0


func attack_loop(_delta: float):
	
	#play the sound of this creature's "voice" and steadily increase it overtime
	var time_ratio = _time_alive / active_time
	voice_sound.volume_db = lerp(-30.0, 20.0, time_ratio)
	
	#if the player ever turns their volume to 0 (really, -80.0db or we'll just say less than -75db), they survive
	if Global.current_player_volume <= -75.0:
		survive()
	
	super.attack_loop(_delta)

#What do we do when the player successfully survives the enemy's encounter?
func survive():
	is_active = false
	print("Player survived " + str(name) + "'s encounter.")
	
	voice_sound.volume_db = -40.0
	
	despawn()

func despawn():
	queue_free()

func _physics_process(delta: float) -> void:
	if not is_active:
		return
	
	_time_alive += delta
	
	#Time alive COUNTS UP to the time we specify that the enemy is active. Once it matches, JUST LIKE DON'TSTOP, the player will be attacked...
	if _time_alive >= active_time:
		attack()
	else:
		#until then, shenanigans
		attack_loop(delta)
