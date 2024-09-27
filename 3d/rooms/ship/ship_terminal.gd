extends TerminalBody

func _ready():
	parent = get_parent().get_parent()
	player = parent.get_parent().get_node("Player")
	main_node_canvas = parent.get_parent().get_parent().get_node("CanvasLayer")
	terminal_scene = load("res://2d/terminal_windows/ship_terminal/ship_terminal.tscn")
