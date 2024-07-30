extends Node2D
var vel = Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var atkStats = {"dir" : Vector2.ZERO, "baseKB" : 0.0, "kbScalar" : 0.0, "hitstun" : 0, "dmg" : 0}
var faceL
var parent

func _physics_process(delta):
	vel.y += gravity * delta
	position += vel * delta

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body == parent:
		return
	if !body.has_method("take_hit"):
		queue_free()
		return
	var tDir = atkStats["dir"]
	if faceL:
		tDir.x = -tDir.x
	body.take_hit(tDir, atkStats["baseKB"], atkStats["kbScalar"], atkStats["dmg"], atkStats["hitstun"])
	queue_free()
