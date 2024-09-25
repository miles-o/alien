extends VBoxContainer
@onready var tree = $HBoxContainer/Tree
@onready var root = tree.create_item()
@onready var currentNode = root
var ship_interior_node
var selected_module
var selected_side
var module_awaiting_input = false
var awaiting_password = false
var program_awaiting_password : String = ""
var passwords : Dictionary = {
	"eject_module": "admin",
	"access_cameras": "password"
}

# ---- the boring stuff ---- #
func _ready():
	root.set_text(0, "root")
	generate_tree("ship")
	tree.set_selected(root, 0)
	ship_interior_node = get_parent().get_parent().get_parent().get_child(1).get_child(0).get_child(0)

func _process(_delta):
	pass

func generate_tree(terminalType):
	match terminalType:
		"ship":
			var ship_controls = tree.create_item(root)
			ship_controls.set_text(0, "ship_controls")
			ship_controls.set_collapsed(true)
			var weapons_systems = tree.create_item(root)
			weapons_systems.set_text(0, "weapons_systems")
			weapons_systems.set_collapsed(true)
			var select_destination = tree.create_item(ship_controls)
			select_destination.set_text(0, "select_destination.exe")
			var ship_cameras = tree.create_item(ship_controls)
			ship_cameras.set_text(0, "ship_cameras.exe")
			var connect_module = tree.create_item(ship_controls)
			connect_module.set_text(0, "connect_module.exe")
			var eject_module = tree.create_item(ship_controls)
			eject_module.set_text(0, "eject_module.exe")
		"space_station":
			var bay_1 = tree.create_item(root)
			bay_1.set_text(0, "bay_1")
			bay_1.set_collapsed(true)
			var bay_2 = tree.create_item(root)
			bay_2.set_text(0, "bay_2")
			bay_2.set_collapsed(true)
			var bay_3 = tree.create_item(root)
			bay_3.set_text(0, "bay_3")
			bay_3.set_collapsed(true)
			var programs = tree.create_item(root)
			programs.set_text(0, "programs")
			programs.set_collapsed(true)
			var eject_module1 = tree.create_item(bay_1)
			eject_module1.set_text(0, "eject_module.exe")
			var eject_module2 = tree.create_item(bay_2)
			eject_module2.set_text(0, "eject_module.exe")
			var eject_module3 = tree.create_item(bay_3)
			eject_module3.set_text(0, "eject_module.exe")
			var list_modules = tree.create_item(programs)
			list_modules.set_text(0, "list_modules.exe")
			var access_cameras = tree.create_item(programs)
			access_cameras.set_text(0, "access_cameras.exe")

func _on_line_edit_text_submitted(new_text):
	# not currently in use, will be useful if using terminal commands later
	var input = new_text
	var inputArray : Array = process_command(input)
	
	if awaiting_password:
		check_password(inputArray)
	elif module_awaiting_input:
		connect_module(inputArray)

func process_command(command):
	var inputArray : Array = []
	$LineEdit.clear()
	command = command.strip_edges().to_lower()
	var temp: String = command
	var last_loop: bool   = false
	
	while true:
		var spaceIndex: int = temp.find(" ")
		var currentWord : String
		if spaceIndex == -1:
			currentWord = temp
			last_loop = true
		else:
			currentWord = temp.substr(0, spaceIndex)
		inputArray.append(currentWord)
		temp = temp.substr(spaceIndex + 1)
		if last_loop == true:
			break
	return inputArray

func _on_tree_item_activated():
	var selected_item : TreeItem = tree.get_selected()
	selected_item.set_collapsed(!selected_item.is_collapsed())
	var selected_text = selected_item.get_text(0)
	match selected_text:
		"select_destination.exe":
			select_destination()
		"ship_cameras.exe":
			ship_cameras()
		"connect_module.exe":
			connect_module(null)
		"eject_module.exe":
			eject_module()
		"list_modules.exe":
			list_modules()
		"access_cameras.exe":
			access_cameras()
# -------------------------- #

# ----- the fun stuff ------ #
func list_destinations():
	$HBoxContainer/Output.text += "destinations\n"

func list_modules():
	$HBoxContainer/Output.text += "modules\n"

func select_destination():
	$HBoxContainer/Output.text += "Select destination\n"

func ship_cameras():
	$HBoxContainer/Output.text += "Launching cameras\n"

func access_cameras():
	awaiting_password = true
	program_awaiting_password = "access_cameras"
	$HBoxContainer/Output.text += "Enter password\n"

func eject_module():
	awaiting_password = true
	program_awaiting_password = "eject_module"
	$HBoxContainer/Output.text += "Enter password\n"

func connect_module(inputArray):
	if module_awaiting_input == false:
		$HBoxContainer/Output.text += "Available modules:\n"
		var ship_interior_node = get_parent().get_parent().get_parent().get_child(1).get_child(0).get_child(0)
		var i = 0
		var current_node
		var node_name : String
		while is_instance_valid(ship_interior_node.get_child(i)):
			current_node = ship_interior_node.get_child(i)
			node_name = current_node.get_name()
			if node_name.substr(0, 6) == "Module":
				$HBoxContainer/Output.text += node_name + "\n"
			i += 1
		module_awaiting_input = true
	elif !is_instance_valid(selected_module):
		var i = 0
		var current_node
		var module_node
		var node_name : String
		while is_instance_valid(ship_interior_node.get_child(i)):
			current_node = ship_interior_node.get_child(i)
			node_name = current_node.get_name()
			if node_name.to_lower() == inputArray[0]:
				selected_module = current_node
				$HBoxContainer/Output.text += node_name + " Selected\n"
				break
			i += 1
		i = 0
		if !is_instance_valid(selected_module):
			$HBoxContainer/Output.text += "Invalid module\n"
			return
		$HBoxContainer/Output.text += "Select side\nAvailable sides:\n"
		while is_instance_valid(selected_module.get_child(0).get_child(i)):
			current_node = selected_module.get_child(0).get_child(i)
			node_name = current_node.get_name()
			if node_name.substr(0, 4) == "Edge":
				$HBoxContainer/Output.text += node_name.substr(4) + "\n"
			i += 1
	else:
		var i = 0
		var current_node
		var node_name : String
		while is_instance_valid(selected_module.get_child(0).get_child(i)):
			current_node = selected_module.get_child(0).get_child(i)
			node_name = current_node.get_name()
			if node_name.substr(4).to_lower() == inputArray[0]:
				selected_side = current_node
				$HBoxContainer/Output.text += node_name +  " Selected\n"
				break
			i += 1
		if !is_instance_valid(selected_side):
			$HBoxContainer/Output.text += "Invalid side name\n"
			return
		# replace edge
		
		var doorway_scene = load("res://3d/rooms/module_components/module_doorway.tscn")
		var doorway = doorway_scene.instantiate()
		doorway.position = selected_side.position
		doorway.rotation = selected_side.rotation
		selected_module.get_child(0).add_child(doorway)
		selected_side.queue_free()
		
		var new_module_scene = load("res://3d/rooms/modules/empty_module.tscn")
		var new_module = new_module_scene.instantiate()
		var module_marker = new_module.get_child(0)
		var doorway_marker = doorway.get_child(1)
		
		# not entirely sure why this maths works but it does dont fuck with it
		new_module.position = doorway_marker.global_position + (doorway_marker.global_position - selected_module.global_position)
		new_module.rotation = selected_module.global_rotation * 2 + doorway_marker.global_rotation
		
		ship_interior_node.add_child(new_module)
		module_awaiting_input = false

func check_password(inputArray):
	var password = passwords[program_awaiting_password]
	if inputArray[0] == password:
		$HBoxContainer/Output.text += "Correct!\nrunning "+program_awaiting_password+"\n"
		awaiting_password = false
		program_awaiting_password = ""
	else:
		$HBoxContainer/Output.text += "Password incorrect, try again\n"
# -------------------------- #
