class_name Terminal
extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		var parent = get_parent()
		parent.close_terminal.emit()

func interact():
	var parent = get_parent()
	parent.open_terminal.emit()
