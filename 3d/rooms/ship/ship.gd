extends Node3D
signal open_terminal
signal close_terminal
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	
	var module_right: Module = load("res://3d/rooms/modules/empty_module.tscn").instantiate()
	module_right.module_coordinates = [2, 0, 1]
	module_right.position.x = 16
	module_right.position.y = 4
	module_right.position.z = -13
	module_right.type = "Default"
	$SpaceshipInterior.add_child(module_right)
	
	var edge_right = module_right.get_child(0).get_node("EdgeLeft")
	var doorway_right = load("res://3d/rooms/module_components/module_doorway.tscn").instantiate()
	doorway_right.position = edge_right.position
	doorway_right.rotation = edge_right.rotation
	edge_right.queue_free()
	module_right.get_child(0).add_child(doorway_right)
	
	var module_left: Module = load("res://3d/rooms/modules/empty_module.tscn").instantiate()
	module_left.module_coordinates = [2, 4, 0]
	module_left.position.x = 16
	module_left.position.y = 4
	module_left.position.z = 13
	module_left.type = "Default"
	$SpaceshipInterior.add_child(module_left)
	
	var edge_left = module_left.get_child(0).get_node("EdgeRight")
	var doorway_left = load("res://3d/rooms/module_components/module_doorway.tscn").instantiate()
	doorway_left.position = edge_left.position
	doorway_left.rotation = edge_left.rotation
	edge_left.queue_free()
	module_left.get_child(0).add_child(doorway_left)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
