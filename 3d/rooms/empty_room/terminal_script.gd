extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var terminal_body: TerminalBody = get_node("TerminalBody")
	terminal_body.player = get_parent().get_parent().get_node("Player")
	terminal_body.main_node_canvas = get_parent().get_parent().get_parent().get_node("CanvasLayer")
	terminal_body.terminal_scene = load("res://2d/terminal_windows/level_terminal/level_terminal.tscn")
