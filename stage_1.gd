extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_blast_zone_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body.has_method("take_hit"):
		body.position = $Spawnpoints.get_child(randi_range(0, 1)).position
		body.velocity = Vector2.ZERO
