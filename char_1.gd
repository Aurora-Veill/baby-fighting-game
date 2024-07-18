extends chars

@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var idlTimer = $TilIdle

func _physics_process(delta):
	movement(delta)
	if !direction:
		anim.stop()
		sprite.set_frame(0)
		if idlTimer.is_stopped():
			idlTimer.start(1)
	else:
		idlTimer.stop()
	if direction > 0:
		sprite.set_flip_h(false)
		if !anim.is_playing():
			anim.play("walk")
	if direction < 0:
		sprite.set_flip_h(true)
		if !anim.is_playing():
			anim.play("walk")

func _on_animation_player_animation_finished(anim_name):
	sprite.set_frame(0)


func _on_til_idle_timeout():
	anim.play("idle")
