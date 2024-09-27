extends TerminalWindow

# DONT FORGET TO LINK CORRECT SCRIPT TO SCENE

# ---- inherited functions that must be defined ---- #
func set_variables():
	canvas_layer = get_parent().get_parent() 
	passwords = {
		"eject_module": "admin",
		"access_cameras": "password"
	}

func generate_tree():
	var program_1: TreeItem = tree.create_item(root)
	program_1.set_text(0, "program_1.exe")
	var program_2: TreeItem = tree.create_item(root)
	program_2.set_text(0, "program_2.exe")

func run_program(program_name):
	match program_name:
			"program_1.exe":
				program_1()
			"program_2.exe":
				program_2()
			_:
				print("Error: program does not exist.")
# ------------------------------------------------- #

# ------------------- programs -------------------- #
func program_1():
	pass # program 1

func program_2():
	pass # program 2
# ------------------------------------------------- #
