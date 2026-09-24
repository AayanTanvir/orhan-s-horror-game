class_name Player
extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.003

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera = $Camera3D
@onready var flashlight = $Camera3D/SpotLight3D
@onready var ray_cast = $Camera3D/RayCast3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))

	if event.is_action_pressed("interact"):
		if ray_cast.is_colliding():
			var hit = ray_cast.get_collider()
			if hit.has_method("interact"):
				hit.interact()
			elif hit.get_parent().has_method("interact"):
				hit.get_parent().interact()

func _process(_delta):
	# Press F to toggle the flashlight light on/off
	if Input.is_action_just_pressed("flashlight_toggle"):
		flashlight.visible = !flashlight.visible

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_forest_trigger_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print("The player has entered the dark woods...")
