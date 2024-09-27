extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interact():
	var ray_cast = $TopOfLadder
	ray_cast.enabled = true
	var top_position = ray_cast.get_collision_point()
	var ship_node = get_parent().get_parent()
	ship_node.player.position = top_position
