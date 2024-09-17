extends VBoxContainer
var tree = Tree.new()
var root = tree.create_item()
var currentNode = root

# Called when the node enters the scene tree for the first time.
func _ready():
	root.set_text(0, "root")
	generate_tree("space_station")
	$HBoxContainer/FileExplorer.text = currentNode.get_text(0) + "\n" + list_children(currentNode)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func generate_tree(terminalType):
	match terminalType:
		"ship":
			var ship_controls = tree.create_item(root)
			ship_controls.set_text(0, "ship_controls")
			var weapons_systems = tree.create_item(root)
			weapons_systems.set_text(0, "weapons_systems")
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
			var bay_2 = tree.create_item(root)
			bay_2.set_text(0, "bay_2")
			var bay_3 = tree.create_item(root)
			bay_3.set_text(0, "bay_3")
			var programs = tree.create_item(root)
			programs.set_text(0, "programs")
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
	var input = new_text
	var inputArray : Array = process_command(input)
	
	match inputArray[0]:
		"ls":
			list_cmd(inputArray)
		"cd":
			change_directory(inputArray)
		"mkdir":
			mkdir(inputArray)
		"run":
			run_program(inputArray)
		_:
			$HBoxContainer/Output.text += "invalid input: " + input + "\n"

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

func change_directory(inputArray):
	if inputArray.size() > 1:
		if inputArray.size() < 3:
			var tempNode = currentNode.get_first_child()
			var val : String = inputArray[1]
			var nodeFound = false
			while tempNode:
				var nodeTxt : String = tempNode.get_text(0)
				if val == nodeTxt:
					currentNode = tempNode
					nodeFound = true
					break
				else:
					tempNode = tempNode.get_next()
			if !nodeFound:
				$HBoxContainer/Output.text += "node not found\n"
		else:
			$HBoxContainer/Output.text += "Expected 2 arguments, recieved " + str(inputArray.size()) + " arguments\n"
	else:
		if currentNode.get_text(0) != "root":
			currentNode = currentNode.get_parent()
		else:
			$HBoxContainer/Output.text += "already at root\n"
	var nodeTxt = currentNode.get_text(0)
	$HBoxContainer/FileExplorer.text = currentNode.get_text(0) + "\n" + list_children(currentNode)

func mkdir(inputArray):
	if inputArray.size() > 1:
		if inputArray.size() < 3:
			$HBoxContainer/Output.text += "creating directory: " + inputArray[1] + "\n"
			var child = tree.create_item(currentNode)
			child.set_text(0, inputArray[1])
		else:
			$HBoxContainer/Output.text += "Expected 2 arguments, recieved " + str(inputArray.size()) + " arguments\n"
	else:
		$HBoxContainer/Output.text += "include directory name\n"

func run_program(inputArray):
	if inputArray.size() > 1:
		if inputArray.size() < 3:
			var tempNode = currentNode.get_first_child()
			var val : String = inputArray[1]
			var nodeFound = false
			while tempNode:
				var nodeTxt : String = tempNode.get_text(0)
				if val == nodeTxt:
					match nodeTxt:
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
					nodeFound = true
					break
				else:
					tempNode = tempNode.get_next()
			if !nodeFound:
				$HBoxContainer/Output.text += "program not found\n"
		else:
			$HBoxContainer/Output.text += "Expected 2 arguments, recieved " + str(inputArray.size()) + " arguments\n"
	else:
		if currentNode.get_text(0) != "root":
			currentNode = currentNode.get_parent()
		else:
			$HBoxContainer/Output.text += "Already at root\n"
	var nodeTxt = currentNode.get_text(0)

func list_cmd(inputArray):
	if inputArray.size() > 1:
		if inputArray.size() < 3:
			match inputArray[1]:
				"destinations":
					list_destinations()
				"modules":
					list_modules()
				_: 
					$HBoxContainer/Output.text += "error\n"
		else:
			$HBoxContainer/Output.text += "Expected 2 arguments, recieved " + str(inputArray.size()) + " arguments\n"
	else:
		list_children(currentNode)

func list_destinations():
	$HBoxContainer/Output.text += "destinations\n"

func list_modules():
	$HBoxContainer/Output.text += "modules\n"

func list_children(root : TreeItem):
	var res : String
	var currentChild = root.get_first_child()
	while currentChild:
		res += "    " + currentChild.get_text(0) + "\n"
		currentChild = currentChild.get_next()
	return res

func select_destination():
	$HBoxContainer/Output.text += "Select destination\n"

func ship_cameras():
	$HBoxContainer/Output.text += "Launching cameras\n"

func access_cameras():
	$HBoxContainer/Output.text += "Accessing cameras\n"

func eject_module():
	$HBoxContainer/Output.text += "Ejecting module\n"

func connect_module():
	$HBoxContainer/Output.text += "Connecting module\n"
