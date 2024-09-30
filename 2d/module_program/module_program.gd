extends Node2D
var ship_interior_node
var left_cluster
var right_cluster
var module_counter: Label
var selected_module
var selected_side
var available_sides : Array
var modules : Array
var module_awaiting_input: bool = false
var coordinates


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ship_interior_node = get_parent().get_parent().get_child(1).get_child(0).get_child(0)
	left_cluster = $Control/HBoxContainer/ModuleButtonClusterLeft
	right_cluster = $Control/HBoxContainer/ModuleButtonClusterRight
	module_counter = $Control/AvailableLabel/Counter
	module_counter.text = str(len(Global.available_modules))
	create_modules()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_modules():
	var i: int = 0
	var current_node
	var node_name : String
	
	module_counter.text = str(len(Global.available_modules))
	
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
		var type = module.type
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
		print(type)
		if type == "fancy":
			button.theme = load("res://2d/module_program/themes/fancy_button.tres")
		elif type == "default": 
			button.theme = load("res://2d/module_program/themes/module_button.tres")
		button.type = type
		button.disabled = true

func button_pressed(temp_coordinates):
	if len(Global.available_modules) > 0:
		load_type_selector()
		coordinates = temp_coordinates
	else:
		var warning = load("res://2d/ui_components/warning.tscn").instantiate()
		warning.position.x = 380
		warning.position.y = 350
		add_child(warning)

func load_type_selector():
	var type_selector = load("res://2d/ui_components/type_selector.tscn").instantiate()
	var padded_button = load("res://2d/ui_components/type_selector_button.tscn")
	type_selector.position.x = 780
	type_selector.position.y = 320
	$Control.add_child(type_selector)
	var type_selector_container = type_selector.get_node("VBoxContainer").get_node("GridContainer")
	var types: Array
	for module in Global.available_modules:
		if !(module in types):
			types.append(module)
	
	for type in types:
		var new_button = padded_button.instantiate()
		new_button.get_node("Button").text = type
		type_selector_container.add_child(new_button)

func add_module(type):
	var type_selector = get_node("Control").get_child(-1)
	type_selector.queue_free()
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
		print("Error: invalid side")
		return
	
	var doorway_scene = load("res://3d/rooms/module_components/module_doorway.tscn")
	var new_module_scene: PackedScene = load("res://3d/rooms/modules/empty_module.tscn")
	var new_module: Node              = new_module_scene.instantiate()
	new_module.position.x = 8 * row
	new_module.position.z = z_position
	new_module.position.y = 4
	new_module.module_coordinates = coordinates
	new_module.type = type
	
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
	
	coordinates = []
	var i = 0
	for l in Global.available_modules:
		if l == type:
			Global.available_modules.remove_at(i)
			break
		i += 1
		
	ship_interior_node.add_child(new_module)
	create_modules()
