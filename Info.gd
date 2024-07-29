extends Control

@export var p1 : chars
@export var p2 : chars
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$p1Info/HP.set_text(str(p1.dmg) + "%")
	$p2Info/HP.set_text(str(p2.dmg) + "%")
