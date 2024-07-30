extends chars
var uProj = preload("res://blockUNormProj.tscn")

func _ready():
	on_ready()
	sprite.set_frame(0)

func _physics_process(delta):
	movement(delta)

func nNorm():
	AtkAnim.play("nNorm")

func dNorm():
	AtkAnim.play("dNorm")

func uNorm():
	AtkAnim.play("uNorm")

func uNormProj():
	var proj = uProj.instantiate()
	proj.parent = self
	if faceL:
		proj.vel = Vector2(-40, -250)
		proj.position = position + Vector2(-4.5, -6.5)
	else:
		proj.vel = Vector2(40, -250)
		proj.position = position + Vector2(4.5, -6.5)
	proj.faceL = faceL
	proj.atkStats = uNormStats
	get_parent().add_child(proj)
