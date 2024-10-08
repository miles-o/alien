extends CharacterBody3D
var menu_scene : PackedScene = load("res://2d/main_menu/main_menu.tscn")

var main_node_canvas
var menu
var terminal_window
const SPEED = 10.0
const JUMP_VELOCITY = 7
const mouse_sensitivity = 0.002
const RAY_LENGTH = 1000.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")*2
var canvas


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	canvas = get_parent().get_parent().get_child(0)
	main_node_canvas = get_parent().get_parent().get_child(0)

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if Input.is_action_just_pressed("interact"):
		if !is_instance_valid(canvas.get_child(0)):
			var ray_cast = $Camera3D/RayCast3D
			ray_cast.enabled = true
			var object = ray_cast.get_collider()
			if is_instance_valid(object) && object.has_method("interact"):
				object.interact()
			
	if Input.is_action_just_pressed("escape"):
		if !is_instance_valid(main_node_canvas.get_child(0)):
			$CanvasLayer/Crosshair.visible = false
			menu = menu_scene.instantiate()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			main_node_canvas.add_child(menu)
		else:
			for child in main_node_canvas.get_children():
				child.queue_free()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			$CanvasLayer/Crosshair.visible = true
	move_and_slide()
