extends CanvasLayer


@onready var texture = $TextureRect
@onready var sound: AudioStreamPlayer = $AudioStreamPlayer

var base_pos: Vector2
var is_jittering: bool = false

func _ready():
	# Save the center position so the image doesn't slowly walk off screen
	base_pos = texture.position

func _process(_delta):
	if is_jittering:
		# Rapidly snap between -15 and 15 pixels. Tweak these numbers for more/less violence.
		texture.position = base_pos + Vector2(randf_range(-15, 15), randf_range(-15, 15))

func trigger_scare(scare_texture: Texture2D, scare_sound: AudioStream):
	texture.modulate.a = 1.0 
	texture.position = base_pos
	is_jittering = true
	
	texture.texture = scare_texture
	sound.stream = scare_sound
	texture.pivot_offset = texture.size / 2.0
	
	# Start it tiny
	texture.scale = Vector2(0.1, 0.1) 
	
	texture.show()
	sound.play()
	
	# 2. Fire off the Tween to handle the jump
	var snap_tween = create_tween()
	snap_tween.tween_property(texture, "scale", Vector2(1, 1), 0.35).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	
	# 3. Wait 1.5 seconds (leaving 0.5s for the fade)
	await get_tree().create_timer(1.0).timeout
	
	# 4. Fade out by tweening the alpha to 0
	var fade_tween = create_tween()
	fade_tween.tween_property(texture, "modulate:a", 0.0, 0.5)
	
	# Wait for the fade to finish before hiding
	await fade_tween.finished
	
	# 5. Clean up
	is_jittering = false
	texture.hide()
	sound.stop()
	texture.position = base_pos
