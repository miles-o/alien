extends VBoxContainer
@onready var tree: Tree = $HBoxContainer/Tree
@onready var root: TreeItem = tree.create_item()
@onready var currentNode: TreeItem     = root
var canvas_layer
var ship_interior_node
var selected_module
var selected_side
var available_sides : Array
var modules : Array
var module_awaiting_input: bool        = false
var awaiting_password: bool            = false
var program_running: bool              = false
var program_awaiting_password : String = ""
var passwords : Dictionary             = {
	"eject_module": "admin",
	"access_cameras": "password"
}

# ---- the boring stuff ---- #
func _ready():
	root.set_text(0, "root")
	generate_tree("ship")
	tree.set_selected(root, 0)
	ship_interior_node = get_parent().get_parent().get_parent().get_child(1).get_child(0).get_child(0)
	canvas_layer = get_parent().get_parent()

func _process(_delta):
	pass

func generate_tree(terminalType):
	match terminalType:
		"ship":
			var ship_controls: TreeItem = tree.create_item(root)
			ship_controls.set_text(0, "ship_controls")
			ship_controls.set_collapsed(true)
			var weapons_systems: TreeItem = tree.create_item(root)
			weapons_systems.set_text(0, "weapons_systems")
			weapons_systems.set_collapsed(true)
			var select_destination: TreeItem = tree.create_item(ship_controls)
			select_destination.set_text(0, "select_destination.exe")
			var ship_cameras: TreeItem = tree.create_item(ship_controls)
			ship_cameras.set_text(0, "ship_cameras.exe")
			var connect_module: TreeItem = tree.create_item(ship_controls)
			connect_module.set_text(0, "connect_module.exe")
			var eject_module: TreeItem = tree.create_item(ship_controls)
			eject_module.set_text(0, "eject_module.exe")
		"space_station":
			var bay_1: TreeItem = tree.create_item(root)
			bay_1.set_text(0, "bay_1")
			bay_1.set_collapsed(true)
			var bay_2: TreeItem = tree.create_item(root)
			bay_2.set_text(0, "bay_2")
			bay_2.set_collapsed(true)
			var bay_3: TreeItem = tree.create_item(root)
			bay_3.set_text(0, "bay_3")
			bay_3.set_collapsed(true)
			var programs: TreeItem = tree.create_item(root)
			programs.set_text(0, "programs")
			programs.set_collapsed(true)
			var eject_module1: TreeItem = tree.create_item(bay_1)
			eject_module1.set_text(0, "eject_module.exe")
			var eject_module2: TreeItem = tree.create_item(bay_2)
			eject_module2.set_text(0, "eject_module.exe")
			var eject_module3: TreeItem = tree.create_item(bay_3)
			eject_module3.set_text(0, "eject_module.exe")
			var list_modules: TreeItem = tree.create_item(programs)
			list_modules.set_text(0, "list_modules.exe")
			var access_cameras: TreeItem = tree.create_item(programs)
			access_cameras.set_text(0, "access_cameras.exe")

func _on_line_edit_text_submitted(new_text):
	# not currently in use, will be useful if using terminal commands later
	var input = new_text
	var inputArray : Array = process_command(input)
	
	if awaiting_password:
		check_password(inputArray)

func process_command(command) -> Array:
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
	if program_running == false:
		var selected_text: String = selected_item.get_text(0)
		match selected_text:
			"select_destination.exe":
				select_destination()
			"ship_cameras.exe":
				ship_cameras()
			"connect_module.exe":
				connect_module()
			"eject_module.exe":
				eject_module()
			"list_modules.exe":
				list_modules()
			"access_cameras.exe":
				access_cameras()
	else:
		$HBoxContainer/Output.text += "program already running\n"
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
	program_running = true
	program_awaiting_password = "access_cameras"
	$HBoxContainer/Output.text += "Enter password\n"

func eject_module():
	program_running = true
	awaiting_password = true
	program_awaiting_password = "eject_module"
	$HBoxContainer/Output.text += "Enter password\n"

func connect_module():
	var program_scene = load("res://2d/module_program/module_program.tscn")
	var program = program_scene.instantiate()
	canvas_layer.add_child(program)

func check_password(inputArray):
	var password = passwords[program_awaiting_password]
	if inputArray[0] == password:
		$HBoxContainer/Output.text += "Correct!\nrunning "+program_awaiting_password+"\n"
		awaiting_password = false
		program_running = false
		program_awaiting_password = ""
	else:
		$HBoxContainer/Output.text += "Password incorrect, try again\n"
# -------------------------- #
