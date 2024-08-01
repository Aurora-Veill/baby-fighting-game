extends Node2D

@export var p1 : chars
@export var p2 : chars
# Called when the node enters the scene tree for the first time.
func _ready():
	p1.set_collision_layer_value(1, true)
	p1.set_collision_layer_value(2, false)
	p1.set_collision_mask_value(1, true)
	p1.set_collision_mask_value(2, false)
	p2.set_collision_layer_value(2, true)
	p2.set_collision_layer_value(1, false)
	p2.set_collision_mask_value(2, true)
	p2.set_collision_mask_value(1, false)
	p1.hitbox.set_collision_layer_value(2, true)
	p1.hitbox.set_collision_mask_value(2, true)
	p2.hitbox.set_collision_layer_value(1, true)
	p2.hitbox.set_collision_mask_value(1, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_blast_zone_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body.has_method("take_hit"):
		body.position = $Spawnpoints.get_child(randi_range(0, 1)).position
		body.velocity = Vector2.ZERO
		body.dmg = 0
