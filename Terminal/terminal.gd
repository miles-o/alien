extends VBoxContainer
var tree = Tree.new()
var root = tree.create_item()
var currentNode = root

# Called when the node enters the scene tree for the first time.
func _ready():
	root.set_text(0, "root")
	generate_tree()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func generate_tree():
	var bay_1 = tree.create_item(root)
	bay_1.set_text(0, "bay_1")
	var bay_2 = tree.create_item(root)
	bay_2.set_text(0, "bay_2")
	var bay_3 = tree.create_item(root)
	bay_3.set_text(0, "bay_3")
	var module = tree.create_item(bay_1)
	module.set_text(0, "module.exe")
	

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

func list_destinations():
	$TextEdit.text += "destinations\n"

func list_modules():
	$TextEdit.text += "modules\n"

func list_children(root : TreeItem):
	var res : String
	var currentChild = root.get_first_child()
	while currentChild:
		res += currentChild.get_text(0) + "\n"
		currentChild = currentChild.get_next()
	$TextEdit.text += res

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
				$TextEdit.text += "node not found\n"
		else:
			$TextEdit.text += "Expected 2 arguments, recieved " + str(inputArray.size()) + " arguments\n"
	else:
		if currentNode.get_text(0) != "root":
			currentNode = currentNode.get_parent()
		else:
			$TextEdit.text += "already at root\n"
	var nodeTxt = currentNode.get_text(0)
	$LineEdit.placeholder_text = currentNode.get_text(0)

func mkdir(name):
	$TextEdit.text += "creating directory: " + name + "\n"
	var child = tree.create_item(currentNode)
	child.set_text(0, name)

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
						"module.exe":
							run_module()
					nodeFound = true
					break
				else:
					tempNode = tempNode.get_next()
			if !nodeFound:
				$TextEdit.text += "program not found\n"
		else:
			$TextEdit.text += "Expected 2 arguments, recieved " + str(inputArray.size()) + " arguments\n"
	else:
		if currentNode.get_text(0) != "root":
			currentNode = currentNode.get_parent()
		else:
			$TextEdit.text += "already at root\n"
	var nodeTxt = currentNode.get_text(0)
func run_module():
	$TextEdit.text += "running module\n"

func _on_line_edit_text_submitted(new_text):
	var input = new_text
	var inputArray : Array = process_command(input)
	
	match inputArray[0]:
		"ls":
			if inputArray.size() > 1:
				if inputArray.size() < 3:
					match inputArray[1]:
						"destinations":
							list_destinations()
						"modules":
							list_modules()
						_: 
							$TextEdit.text += "error\n"
				else:
					$TextEdit.text += "Expected 2 arguments, recieved " + str(inputArray.size()) + " arguments\n"
			else:
				list_children(currentNode)
		"cd":
			change_directory(inputArray)
		"mkdir":
			if inputArray.size() > 1:
				if inputArray.size() < 3:
					mkdir(inputArray[1])
				else:
					$TextEdit.text += "Expected 2 arguments, recieved " + str(inputArray.size()) + " arguments\n"
			else:
				$TextEdit.text += "include directory name\n"
		"run":
			run_program(inputArray)
		_:
			$TextEdit.text += "invalid input: " + input + "\n"
