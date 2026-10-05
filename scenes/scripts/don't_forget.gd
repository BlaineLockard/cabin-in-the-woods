extends BaseEnemy
class_name DontForget

@onready var voice_sound: AudioStreamPlayer = $VoiceSound
@onready var kill_screen = $CanvasLayer
@onready var hand = $CanvasLayer/TheHand
@onready var eyes = $CanvasLayer/TheEyes
@onready var boss = $CanvasLayer/REALEyes

var phase_two_triggered: bool = false
var last_flash_time: float = 0.0

var original_boss_pos: Vector2
var is_jittering: bool = false

func google_search(query: String):
	var url = "https://www.google.com/search?q=" + query.uri_encode()
	OS.shell_open(url)

func _on_spawn():
	google_search(Global.system_name + " current location")
	
	voice_sound.volume_db = 10.0
	voice_sound.play()
	
	kill_screen.show()
	eyes.hide()
	hand.hide()
	boss.hide()
	
	# go 100m into the ground so we no see
	global_position.y = -100.0


func attack_loop(_delta: float):
	# if the player ever turns on power, they survive
	if Global.power_on:
		survive()
		return # Exit early so we don't accidentally run attack logic on the same frame
		
	# check for if it's been five seconds
	if _time_alive >= 15.0 and not phase_two_triggered:
		phase_two_triggered = true
		voice_sound.volume_db = 25.0
		google_search("i see you, " + Global.system_name)
		last_flash_time = _time_alive # lock in the timer for the eye flashes
		
	# after five seconds, flash the eyes on screen every second
	if phase_two_triggered:
		if _time_alive - last_flash_time >= 1.0:
			last_flash_time = _time_alive
			flash_eyes()
			
	# if it's been 10 seconds, begin the attack function
	# (Assuming active_time isn't already handling this in your BaseEnemy script)
	if _time_alive >= 30.0:
		attack()
	
	super.attack_loop(_delta)

func flash_eyes():
	eyes.show()
	await get_tree().create_timer(0.10).timeout
	eyes.hide()
	
	eyes.show()
	await get_tree().create_timer(0.10).timeout
	eyes.hide()

#What do we do when the player successfully survives the enemy's encounter?
func survive():
	is_active = false
	print("Player survived " + str(name) + "'s encounter.")
	
	voice_sound.volume_db = -40.0
	google_search("i lost you " + Global.system_name)
	
	despawn()
	

func attack():
	is_active = false
	print("DontForget triggered! Ending game...")
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -40.0)
	player.set_process_input(false)
	player.set_process_unhandled_input(false)
	
	#show the evil eyes on the screen
	kill_screen.show()
	get_tree().paused = true
	
	boss.show()
	original_boss_pos = boss.position
	is_jittering = true
	await get_tree().create_timer(2.5).timeout
	
	#then, from 0, increase the size of the hand until it fills the screen, simulating the player's camera being grabbed
	hand.show()
	hand.pivot_offset = hand.size / 2.0
	hand.scale = Vector2.ZERO # Start invisible/tiny
	
	var tween = create_tween()
	
	tween.tween_property(hand, "scale", Vector2(100.0, 100.0), 0.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	
	await tween.finished
	
	hurt_player.emit(name)
	hurt_player.emit(name)
	hurt_player.emit(name)
	hurt_player.emit(name)
	hurt_player.emit(name)

func _physics_process(delta: float) -> void:
	if not is_active:
		if is_jittering:
			boss.position = original_boss_pos + Vector2(randf_range(-10.0, 10.0), randf_range(-10.0, 10.0))
		return
	
	
	
	_time_alive += delta
	
	attack_loop(delta)
