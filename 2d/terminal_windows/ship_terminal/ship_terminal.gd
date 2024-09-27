extends TerminalWindow

# ---- inherited functions that must be defined ---- #
func set_variables():
	canvas_layer = get_parent().get_parent()
	passwords = {
		"eject_module": "admin",
		"access_cameras": "password"
	}

func generate_tree():
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

func run_program(program_name):
	match program_name:
			"select_destination.exe":
				select_destination()
			"ship_cameras.exe":
				ship_cameras()
			"connect_module.exe":
				connect_module()
			"eject_module.exe":
				eject_module()
			_:
				print("Error: program does not exist.")
# ------------------------------------------------- #

# ------------------- programs -------------------- #
func list_destinations():
	$HBoxContainer/Output.text += "destinations\n"

func select_destination():
	$HBoxContainer/Output.text += "Select destination\n"

func ship_cameras():
	$HBoxContainer/Output.text += "Launching cameras\n"

func eject_module():
	program_running = true
	awaiting_password = true
	program_awaiting_password = "eject_module"
	$HBoxContainer/Output.text += "Enter password\n"

func connect_module():
	var program_scene = load("res://2d/module_program/module_program.tscn")
	var program = program_scene.instantiate()
	canvas_layer.add_child(program)
# ------------------------------------------------- #
