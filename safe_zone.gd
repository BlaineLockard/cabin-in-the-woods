extends Area3D

signal entered

@export var hitpoints: GameEndManager
@export var desk_light: SpotLight3D

## when you go into the safe zone, your health replenishes, the bad effects go away, and enemies cant get you, Yippee!
func on_body_entered(body:Node3D):
	if Global.power_on == true:
		if body.is_in_group("player"):
			Global.in_safe_zone = true
			if hitpoints:
				print(hitpoints.allowed_hits)
				hitpoints.allowed_hits = 2
				body.should_limp = false
				##something here for sight range
				
				
				
				print("yo you entered THE SAFE ZONE, hits at ", hitpoints.allowed_hits)
				print(body.should_limp)
			else:
				print("everything doesnt work and its all your fault")
	else:
		if desk_light:
			desk_light.light_energy = 0
			print("Power's out, you're gonna die lol")
				
## when you exit the safe zone, enemies can spawn again
func on_body_exiting(body:Node3D):
	if body.is_in_group("player"):
		Global.in_safe_zone = false
		print("you are no longer safe...")
func _ready() -> void:
	self.body_entered.connect(on_body_entered)
	self.body_exited.connect(on_body_exiting)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
