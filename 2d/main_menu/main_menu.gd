extends Node2D

@export var level_scene : PackedScene
var level
var player_script = load("res://player/player.gd")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_quit_pressed():
	get_tree().quit()


func _on_start_pressed():
	if !is_instance_valid(get_parent().get_parent().get_child(1)):
		level = level_scene.instantiate()
		get_parent().get_parent().add_child(level)
	else:
		get_parent().get_parent().get_child(1).get_child(1).free_menu()
	queue_free()
