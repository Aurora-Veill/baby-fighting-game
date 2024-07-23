extends CharacterBody2D
class_name chars

@export var speed = 175.0
@export var jump = -400.0
@export var MaxMIJumps = 1
@export var MAjump = -400.0
@export var WalkAnim : AnimationPlayer
@export var IdleAnim : AnimationPlayer
@export var AtkAnim : AnimationPlayer
@export var sprite : Sprite2D
@export var idlTimer : Timer
@export var hitbox : Area2D
var MIJumps = MaxMIJumps
var direction
var isAttacking = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func on_ready():
	WalkAnim.animation_finished.connect(_on_walk_anim_animation_finished)
	IdleAnim.animation_finished.connect(_on_idle_anim_animation_finished)
	AtkAnim.animation_finished.connect(_on_atk_anim_animation_finished)
	idlTimer.timeout.connect(_on_til_idle_timeout)

func movement(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		MIJumps = MaxMIJumps
	if isAttacking:
		velocity.x = move_toward(velocity.x, 0, speed)
		move_and_slide()
		return
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
	if !direction:
		if WalkAnim.is_playing():
			WalkAnim.stop()
			sprite.set_frame(0)
		if idlTimer.is_stopped():
			idlTimer.start(1)
	else:
		idlTimer.stop()
		if IdleAnim.is_playing():
			IdleAnim.stop()
	if direction > 0:
		sprite.set_flip_h(false)
		if !WalkAnim.is_playing():
			WalkAnim.play("walk")
	if direction < 0:
		sprite.set_flip_h(true)
		if !WalkAnim.is_playing():
			WalkAnim.play("walk")
	if Input.is_action_just_pressed("normalAtk"):
		if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			fNorm()
		if Input.is_action_pressed("down"):
			dNorm()
		if Input.is_action_pressed("up"):
			uNorm()
		nNorm()
		isAttacking = true
		WalkAnim.stop()
		IdleAnim.stop()
		idlTimer.stop()

func _on_til_idle_timeout():
	IdleAnim.play("idle")

func _on_idle_anim_animation_finished(anim_name):
	IdleAnim.play("idle")

func _on_walk_anim_animation_finished(anim_name):
	sprite.set_frame(0)

func _on_atk_anim_animation_finished(anim_name):
	isAttacking = false

func nNorm():
	pass

func fNorm():
	pass

func uNorm():
	pass

func dNorm():
	pass
