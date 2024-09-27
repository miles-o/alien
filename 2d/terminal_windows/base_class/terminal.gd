class_name TerminalWindow
extends VBoxContainer
@onready var tree: Tree = $HBoxContainer/Tree
@onready var root: TreeItem = tree.create_item()
@onready var currentNode: TreeItem     = root
var canvas_layer
var selected_module
var selected_side
var available_sides : Array
var modules : Array
var module_awaiting_input: bool        = false
var awaiting_password: bool            = false
var program_running: bool              = false
var program_awaiting_password : String = ""
var passwords : Dictionary             

# ---- do not need modification in child class --- #
func _ready():
	root.set_text(0, "root")
	generate_tree()
	tree.set_selected(root, 0)
	set_variables()

func _process(_delta):
	pass

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
	var selected_text: String = selected_item.get_text(0)
	if selected_text.substr(selected_text.length()-4) == ".exe":
		if program_running == false:
			run_program(selected_text)
		else:
			$HBoxContainer/Output.text += "Error: Program already running\n"

func check_password(inputArray):
	var password = passwords[program_awaiting_password]
	if inputArray[0] == password:
		$HBoxContainer/Output.text += "Correct!\nrunning "+program_awaiting_password+"\n"
		awaiting_password = false
		program_running = false
		program_awaiting_password = ""
	else:
		$HBoxContainer/Output.text += "Password incorrect, try again\n"
# ------------------------------------------------ #

# -------- must be defined in child class -------- #
func run_program(program_name):
	match program_name:
		_:
			print("run_program() not defined. Please define function in child class")

func set_variables():
	print("set_variables() not defined. Please define function in child class")

func generate_tree():
	print("generate_tree() not defined. Please define function in child class")
# ------------------------------------------------ #
