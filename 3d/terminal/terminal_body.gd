class_name TerminalBody
extends Node3D
var parent 
var player 
var main_node_canvas 
var terminal_scene : PackedScene = load("res://2d/terminal_windows/ship_terminal/ship_terminal.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interact():
	player.get_node("CanvasLayer/Crosshair").visible = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var terminal_window = terminal_scene.instantiate()
	main_node_canvas.add_child(terminal_window)
