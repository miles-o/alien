extends CharacterBody3D
@export var terminal_scene : PackedScene

var terminal_window
const SPEED = 10.0
const JUMP_VELOCITY = 6
const mouse_sensitivity = 0.002
const RAY_LENGTH = 1000.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

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
		var ray_cast = $Camera3D/RayCast3D
		ray_cast.enabled = true
		var object = ray_cast.get_collider()
		if is_instance_valid(object) && object.has_method("interact"):
			object.interact()
	
	move_and_slide()



func _on_terminal_3d_open_terminal():
	$CanvasLayer/Crosshair.visible = false
	terminal_window = terminal_scene.instantiate()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$CanvasLayer.add_child(terminal_window)


func _on_terminal_3d_close_terminal():
	if is_instance_valid(terminal_window):
		terminal_window.queue_free()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		$CanvasLayer/Crosshair.visible = true


func _on_ship_climb_ladder(top_position):
	position = top_position
