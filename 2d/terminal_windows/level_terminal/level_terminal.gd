extends TerminalWindow

# DONT FORGET TO LINK CORRECT SCRIPT TO SCENE

# ---- inherited functions that must be defined ---- #
func set_variables():
	canvas_layer = get_parent().get_parent().get_parent()
	passwords = {
		"eject_module": "admin",
		"access_cameras": "password"
	}

func generate_tree():
	var program_1: TreeItem = tree.create_item(root)
	program_1.set_text(0, "release_default_module.exe")
	var program_2: TreeItem = tree.create_item(root)
	program_2.set_text(0, "release_fancy_module.exe")

func run_program(program_name):
	match program_name:
			"release_default_module.exe":
				release_module("default")
			"release_fancy_module.exe":
				release_module("fancy")
			_:
				print("Error: program does not exist.")
# ------------------------------------------------- #

# ------------------- programs -------------------- #
func release_module(type):
	Global.available_modules.append(type)


# ------------------------------------------------- #
