extends CharacterBody2D
class_name chars

@export var speed = 175.0
@export var jump = -400.0
@export var MaxMIJumps = 1
@export var MAjump = -400.0
@export var weight = 10
@export var nNormStats = {"dir" : Vector2.ZERO, "baseKB" : 0.0, "kbScalar" : 0.0, "hitstun" : 0, "dmg" : 0}
@export var dNormStats = {"dir" : Vector2.ZERO, "baseKB" : 0.0, "kbScalar" : 0.0, "hitstun" : 0, "dmg" : 0}
@export var uNormStats = {"dir" : Vector2.ZERO, "baseKB" : 0.0, "kbScalar" : 0.0, "hitstun" : 0, "dmg" : 0}
@export var fNormStats = {"dir" : Vector2.ZERO, "baseKB" : 0.0, "kbScalar" : 0.0, "hitstun" : 0, "dmg" : 0}
@export var nAirStats = {"dir" : Vector2.ZERO, "baseKB" : 0.0, "kbScalar" : 0.0, "hitstun" : 0, "dmg" : 0}
@export var dAirStats = {"dir" : Vector2.ZERO, "baseKB" : 0.0, "kbScalar" : 0.0, "hitstun" : 0, "dmg" : 0}
@export var uAirStats = {"dir" : Vector2.ZERO, "baseKB" : 0.0, "kbScalar" : 0.0, "hitstun" : 0, "dmg" : 0}
@export var fAirStats = {"dir" : Vector2.ZERO, "baseKB" : 0.0, "kbScalar" : 0.0, "hitstun" : 0, "dmg" : 0}
@export var WalkAnim : AnimationPlayer
@export var IdleAnim : AnimationPlayer
@export var AtkAnim : AnimationPlayer
@export var sprite : Sprite2D
@export var idlTimer : Timer
@export var hitbox : Area2D
@export var controls = {"left" : "left1", "right" : "right1", "up" : "up1", "normalAtk" : "normalAtk1", "down" : "down1", "jump" : "jump1"}
var MIJumps = MaxMIJumps
var direction
var isAttacking = false
var hitstun = 0
var dmg = 0
var hasHit = []
var faceL = false
var aMoveX = 0
var aMoveY = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func on_ready():
	WalkAnim.animation_finished.connect(_on_walk_anim_animation_finished)
	IdleAnim.animation_finished.connect(_on_idle_anim_animation_finished)
	AtkAnim.animation_finished.connect(_on_atk_anim_animation_finished)
	idlTimer.timeout.connect(_on_til_idle_timeout)
	hitbox.body_shape_entered.connect(deal_hit)

func movement(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		MIJumps = MaxMIJumps
	direction = Input.get_axis(controls["left"], controls["right"])
	if hitstun > 0:
		hitstun -= 1
		move_and_slide()
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, speed)
			hitstun = 0
		return
	if isAttacking:
		if aMoveX != 0:
			velocity.x = aMoveX
			if faceL:
				velocity.x *= -1
		if aMoveY != 0:
			velocity.y = aMoveY
		move_and_slide()
		return
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	if Input.is_action_just_pressed(controls["jump"]):
		if is_on_floor():
			velocity.y = jump
		elif MIJumps > 0:
			velocity.y = MAjump
			MIJumps -= 1
	if Input.is_action_just_pressed("tester"):
		take_hit(Vector2(.1, -.9), 3000, 10, 2, 60)
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
		if faceL:
			scale.x = -1
		faceL = false
		if !WalkAnim.is_playing():
			WalkAnim.play("walk")
	if direction < 0:
		if !faceL:
			scale.x = -1
		faceL = true
		if !WalkAnim.is_playing():
			WalkAnim.play("walk")
	if Input.is_action_just_pressed(controls["normalAtk"]):
		isAttacking = true
		WalkAnim.stop()
		IdleAnim.stop()
		idlTimer.stop()
		if is_on_floor():
			if Input.is_action_pressed(controls["left"]) or Input.is_action_pressed(controls["right"]):
				fNorm()
				return
			if Input.is_action_pressed(controls["down"]):
				dNorm()
				return
			if Input.is_action_pressed(controls["up"]):
				uNorm()
				return
			nNorm()
			return
		if Input.is_action_pressed(controls["left"]) or Input.is_action_pressed(controls["right"]):
			fAir()
			return
		if Input.is_action_pressed(controls["down"]):
			dAir()
			return
		if Input.is_action_pressed(controls["up"]):
			uAir()
			return
		nAir()

func _on_til_idle_timeout():
	IdleAnim.play("idle")

func _on_idle_anim_animation_finished(anim_name):
	IdleAnim.play("idle")

func _on_walk_anim_animation_finished(anim_name):
	sprite.set_frame(0)

func _on_atk_anim_animation_finished(anim_name):
	isAttacking = false
	hasHit = []

func nNorm():
	isAttacking = false

func fNorm():
	isAttacking = false

func uNorm():
	isAttacking = false

func dNorm():
	isAttacking = false
	
func nAir():
	isAttacking = false

func fAir():
	isAttacking = false

func uAir():
	isAttacking = false

func dAir():
	isAttacking = false

func take_hit(dir : Vector2, baseKB, kbScalar, Dmg, Hitstun):
	hitstun = Hitstun
	velocity = dir.normalized() * (baseKB + (kbScalar * dmg)) / weight
	dmg += Dmg

func deal_hit(body_rid, body, body_shape_index, local_shape_index):
	if body == self:
		return
	if body in hasHit:
		return
	if !body.has_method("take_hit"):
		return
	var atkStats
	if AtkAnim.get_current_animation() == "nNorm":
		atkStats = nNormStats
	elif AtkAnim.get_current_animation() == "dNorm":
		atkStats = dNormStats
	elif AtkAnim.get_current_animation() == "uNorm":
		atkStats = uNormStats
	elif AtkAnim.get_current_animation() == "fNorm":
		atkStats = fNormStats
	if AtkAnim.get_current_animation() == "nAir":
		atkStats = nAirStats
	elif AtkAnim.get_current_animation() == "dAir":
		atkStats = dAirStats
	elif AtkAnim.get_current_animation() == "uAir":
		atkStats = uAirStats
	elif AtkAnim.get_current_animation() == "fAir":
		atkStats = fAirStats
	var tDir = atkStats["dir"]
	if faceL:
		tDir.x = -tDir.x
	body.take_hit(tDir, atkStats["baseKB"], atkStats["kbScalar"], atkStats["dmg"], atkStats["hitstun"])
	hasHit.append(body)

func setAMove(vec : Vector2):
	aMoveX = vec.x
	aMoveY = vec.y

func setVel(vel : Vector2):
	velocity = vel
