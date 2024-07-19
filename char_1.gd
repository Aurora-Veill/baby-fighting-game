extends chars

@onready var WalkAnim = $WalkAnim
@onready var IdleAnim = $IdleAnim
@onready var sprite = $Sprite2D
@onready var idlTimer = $TilIdle

func _ready():
	sprite.set_frame(0)

func _physics_process(delta):
	movement(delta)
	if !direction:
		if WalkAnim.is_playing():
			WalkAnim.stop()
			sprite.set_frame(0)
		if idlTimer.is_stopped():
			idlTimer.start(1)
	else:
		idlTimer.stop()
	if direction > 0:
		sprite.set_flip_h(false)
		if !WalkAnim.is_playing():
			WalkAnim.play("walk")
	if direction < 0:
		sprite.set_flip_h(true)
		if !WalkAnim.is_playing():
			WalkAnim.play("walk")

func _on_til_idle_timeout():
	IdleAnim.play("idle")

func _on_idle_anim_animation_finished(anim_name):
	IdleAnim.play("idle")

func _on_walk_anim_animation_finished(anim_name):
	sprite.set_frame(0)

func nNorm():
	print("jab")
