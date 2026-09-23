class_name CharacterController extends CharacterBody3D

@export_category("Camera")
@export var headbob := true
@export var lookSens := 0.003
@export_category("Movement")
@export var canMove := true
@export var canJump := true
@export var canSprint := true
@export var jumpVel := 5.0
@export var speed := 5.0
@export var speedSprint := 7.0
@export var groundAccel := 14.0
@export var groundDecel := 10.0
@export var groundFriction := 6.0
@export var airCap := 1.85
@export var airAccel := 800.0
@export var airMoveSpeed := 500.0


@onready var camera := $head/Camera3D
@onready var head: Node3D = $head
@onready var hud: HUD = $PlayerHud


const HEADBOB_AMOUNT = 0.03
const HEADBOB_FREQ = 3

var desiredDir := Vector3.ZERO
var camDesiredDir := Vector3.ZERO
var headbobTime := 0.0

var noclip := false
var noClipSpeedMult := 3.0

var just_in_air := false
var _spawn_grace := true

##Gets the players current speed.
func getMoveSpeed():
	if canSprint and Input.is_action_pressed("sprint"):
		return speedSprint 
	else:
		return speed


func _ready() -> void:
	hud.player = self
	for child in $model.find_children("*", "VisualInstance3D"):
		child.set_layer_mask_value(1, false)
		child.set_layer_mask_value(2, false)
	
	move_and_slide()


func _unhandled_input(event) -> void:
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * lookSens)
			camera.rotate_x(-event.relative.y * lookSens)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
			
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			noClipSpeedMult = min(100.0, noClipSpeedMult * 1.1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			noClipSpeedMult = max(0.1, noClipSpeedMult * 0.9)
	
	if event.is_action_pressed("ui_cancel"):
		toggleMouseMode()


func _do_noclip(delta) -> bool:
	if Input.is_action_just_pressed("noclip") and OS.has_feature("debug"):
		noclip = !noclip
		noClipSpeedMult = 3.0
	
	$CollisionShape3D.disabled = noclip
	if not noclip:
		return false
	var noClipSpeed = getMoveSpeed() * noClipSpeedMult
	
	global_position += camDesiredDir * noClipSpeed * delta
	return true


func _doHeadbob(delta) -> void:
	headbobTime += delta * self.velocity.length()
	camera.transform.origin = Vector3(
		cos(headbobTime * HEADBOB_FREQ * 0.5) * HEADBOB_AMOUNT,
		sin(headbobTime * HEADBOB_FREQ) * HEADBOB_AMOUNT,
		0
	)


func _doGroundPhysics(delta) -> void:
	var curSpeedInDir = self.velocity.dot(desiredDir)
	var maxDist = getMoveSpeed() - curSpeedInDir
	if maxDist > 0:
		var accel = groundAccel * delta * getMoveSpeed()
		accel = min(accel, maxDist)
		self.velocity += accel * desiredDir
	
	var control = max(self.velocity.length(), groundDecel)
	var drop = control * groundFriction * delta
	var newSpeed = max(self.velocity.length() - drop, 0.0)
	if self.velocity.length() > 0:
		newSpeed /= self.velocity.length()
	self.velocity *= newSpeed
	
	if headbob:
		_doHeadbob(delta)


func _doAirPhysics(delta) -> void:
	self.velocity.y += get_gravity().y * delta
	
	var curSpeedInDir = self.velocity.dot(desiredDir)
	var maxSpeed = min((airMoveSpeed * desiredDir).length(), airCap)
	var maxDist = maxSpeed - curSpeedInDir
	if maxDist > 0:
		var accel = airAccel * airMoveSpeed * delta
		accel = min(accel, maxDist)
		self.velocity += accel * desiredDir


func _physics_process(delta: float) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and canMove:
		var inputDir = Input.get_vector("left", "right", "up", "down").normalized()
		desiredDir = self.global_transform.basis * Vector3(inputDir.x, 0, inputDir.y)
		camDesiredDir = camera.global_transform.basis * Vector3(inputDir.x, 0, inputDir.y)
	else:
		desiredDir = Vector3.ZERO
		camDesiredDir = Vector3.ZERO
	
	if not _do_noclip(delta):
			
		if is_on_floor():
			just_in_air = false
			_spawn_grace = false
			if Input.is_action_just_pressed("jump") and canJump and canMove:
				self.velocity.y = jumpVel
			_doGroundPhysics(delta)
		else:
			just_in_air = true
			_doAirPhysics(delta)
	
		move_and_slide()


## Removes all movement from player. No walking, jumping, looking, etc.
## Player can still interact with with objects in front of them.
func toggleMovement():
	canMove = !canMove

## Removes all controls from player. No input is allowed
func toggleControl():
	pass

##Swaps mouse between being locked in the game and being free.
func toggleMouseMode():
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
