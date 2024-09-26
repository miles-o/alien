extends Node2D
var ship_interior_node
var left_cluster
var right_cluster
var selected_module
var selected_side
var available_sides : Array
var modules : Array
var module_awaiting_input: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ship_interior_node = get_parent().get_parent().get_child(1).get_child(0).get_child(0)
	left_cluster = $Control/HBoxContainer/ModuleButtonClusterLeft
	right_cluster = $Control/HBoxContainer/ModuleButtonClusterRight
	create_modules()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_modules():
	var i: int = 0
	var current_node
	var node_name : String
	
	while is_instance_valid(ship_interior_node.get_child(i)):
		current_node = ship_interior_node.get_child(i)
		node_name = current_node.get_name()
		if current_node is Module:
			modules.append(current_node)
		i += 1


	
	for module in modules:
		var row = module.module_coordinates[0]
		var column = module.module_coordinates[1]
		var side = module.module_coordinates[2]
		var button_row
		var button: Button
		var cluster
		
		if side == 0:
			cluster = left_cluster
		elif side == 1:
			cluster = right_cluster
		else:
			print("error, invalid side")
			return
		
		if row != 0 :
			button_row = cluster.get_child(0).get_child(row-1)
			button = button_row.get_child(0).get_child(column).get_child(0)
			button.disabled = false
			button.coordinates = [row-1, column, side]
			button.type = "available"
		if row != 4 :
			button_row = cluster.get_child(0).get_child(row+1)
			button = button_row.get_child(0).get_child(column).get_child(0)
			button.disabled = false
			button.coordinates = [row+1, column, side]
			button.type = "available"
		if column != 0 :
			button_row = cluster.get_child(0).get_child(row)
			button = button_row.get_child(0).get_child(column-1).get_child(0)
			button.disabled = false
			button.coordinates = [row, column-1, side]
			button.type = "available"
		if column != 4 :
			button_row = cluster.get_child(0).get_child(row)
			button = button_row.get_child(0).get_child(column+1).get_child(0)
			button.disabled = false
			button.coordinates = [row, column+1, side]
			button.type = "available"
	
	for module in modules:
		var row = module.module_coordinates[0]
		var column = module.module_coordinates[1]
		var side = module.module_coordinates[2]
		var cluster
		if side == 0:
			cluster = left_cluster
		elif side == 1:
			cluster = right_cluster
		else:
			print("error, invalid side")
			return
		var button_row = cluster.get_child(0).get_child(row)
		var button: Button = button_row.get_child(0).get_child(column).get_child(0)
		button.theme = load("res://2d/module_program/module_button.tres")
		button.disabled = true
		button.type = "taken"

func button_pressed(coordinates):
	var row = coordinates[0]
	var column = coordinates[1]
	var side = coordinates[2]
	var cluster
	var z_position
	if side == 0:
		cluster = left_cluster
		z_position = 8 * (4-column) + 13
	elif side == 1:
		cluster = right_cluster
		z_position = -(8 * column + 13)
	else:
		print("error, invalid side")
		return
	var doorway_scene = load("res://3d/rooms/module_components/module_doorway.tscn")
	var new_module_scene: PackedScene = load("res://3d/rooms/modules/empty_module.tscn")
	var new_module: Node              = new_module_scene.instantiate()
	new_module.position.x = 8 * row
	new_module.position.z = z_position
	new_module.position.y = 4
	new_module.module_coordinates = coordinates
	
	
	var button_row
	var button: Button
	if row != 0 :
		button_row = cluster.get_child(0).get_child(row-1)
		button = button_row.get_child(0).get_child(column).get_child(0)
		if button.type == "taken":
			var connected_module
			var edge = new_module.get_child(0).get_node("EdgeTop")
			var doorway = doorway_scene.instantiate()
			doorway.position = edge.position
			doorway.rotation = edge.rotation
			new_module.get_child(0).add_child(doorway)
			edge.queue_free()
			var temp_coordinates = [row - 1, column, side]
			for module in modules:
				
				if module.module_coordinates == temp_coordinates:
					connected_module = module
			
			var connected_edge = connected_module.get_child(0).get_node("EdgeBottom")
			var connected_doorway = doorway_scene.instantiate()
			connected_doorway.position = connected_edge.position
			connected_doorway.rotation = connected_edge.rotation
			connected_module.get_child(0).add_child(connected_doorway)
			connected_edge.queue_free()
	if row != 4 :
		button_row = cluster.get_child(0).get_child(row+1)
		button = button_row.get_child(0).get_child(column).get_child(0)
		if button.type == "taken":
			var connected_module
			var edge = new_module.get_child(0).get_node("EdgeBottom")
			var doorway = doorway_scene.instantiate()
			doorway.position = edge.position
			doorway.rotation = edge.rotation
			new_module.get_child(0).add_child(doorway)
			edge.queue_free()
			var temp_coordinates = [row + 1, column, side]
			for module in modules:
				
				if module.module_coordinates == temp_coordinates:
					connected_module = module
			
			var connected_edge = connected_module.get_child(0).get_node("EdgeTop")
			var connected_doorway = doorway_scene.instantiate()
			connected_doorway.position = connected_edge.position
			connected_doorway.rotation = connected_edge.rotation
			connected_module.get_child(0).add_child(connected_doorway)
			connected_edge.queue_free()
	if column != 0 :
		button_row = cluster.get_child(0).get_child(row)
		button = button_row.get_child(0).get_child(column-1).get_child(0)
		if button.type == "taken":
			var connected_module
			var edge = new_module.get_child(0).get_node("EdgeLeft")
			var doorway = doorway_scene.instantiate()
			doorway.position = edge.position
			doorway.rotation = edge.rotation
			new_module.get_child(0).add_child(doorway)
			edge.queue_free()
			var temp_coordinates = [row, column-1, side]
			for module in modules:
				
				if module.module_coordinates == temp_coordinates:
					connected_module = module
			
			var connected_edge = connected_module.get_child(0).get_node("EdgeRight")
			var connected_doorway = doorway_scene.instantiate()
			connected_doorway.position = connected_edge.position
			connected_doorway.rotation = connected_edge.rotation
			connected_module.get_child(0).add_child(connected_doorway)
			connected_edge.queue_free()
	if column != 4 :
		button_row = cluster.get_child(0).get_child(row)
		button = button_row.get_child(0).get_child(column+1).get_child(0)
		if button.type == "taken":
			var connected_module
			var edge = new_module.get_child(0).get_node("EdgeRight")
			var doorway = doorway_scene.instantiate()
			doorway.position = edge.position
			doorway.rotation = edge.rotation
			new_module.get_child(0).add_child(doorway)
			edge.queue_free()
			var temp_coordinates = [row, column+1, side]
			for module in modules:
				
				if module.module_coordinates == temp_coordinates:
					connected_module = module
			
			var connected_edge = connected_module.get_child(0).get_node("EdgeLeft")
			var connected_doorway = doorway_scene.instantiate()
			connected_doorway.position = connected_edge.position
			connected_doorway.rotation = connected_edge.rotation
			connected_module.get_child(0).add_child(connected_doorway)
			connected_edge.queue_free()
	
	ship_interior_node.add_child(new_module)
	create_modules()
