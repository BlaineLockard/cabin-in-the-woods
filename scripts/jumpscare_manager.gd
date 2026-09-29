extends CanvasLayer

@onready var texture = $TextureRect
@onready var sound = $AudioStreamPlayer

func trigger_scare(scare_texture: Texture2D, scare_sound: AudioStream):
	texture.texture = scare_texture
	sound.stream = scare_sound
	
	texture.show()
	sound.play()
	
	# Any effects for the jumpscare? In this case, just wait 2 seconds and hide.
	await get_tree().create_timer(2.0).timeout
	texture.hide()
