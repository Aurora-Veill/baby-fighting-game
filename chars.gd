extends CharacterBody2D
class_name chars

@export var speed = 175.0
@export var jump = -400.0
@export var MaxMIJumps = 1
@export var MAjump = -400.0
var MIJumps = MaxMIJumps
var direction

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func movement(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		MIJumps = MaxMIJumps
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump
		elif MIJumps > 0:
			velocity.y = MAjump
			MIJumps -= 1
	direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()
	if Input.is_action_just_pressed("normalAtk"):
		if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			fNorm()
		if Input.is_action_pressed("down"):
			dNorm()
		if Input.is_action_pressed("up"):
			uNorm()
		nNorm()

func nNorm():
	pass

func fNorm():
	pass

func uNorm():
	pass

func dNorm():
	pass
