extends CharacterBody3D

const ROTATION_SPEED = 180

@export var gravity_toggle = true

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var state = 'idle'
#@onready var animation_player = $Visual/AnimationPlayer
#@onready var mesh_model = $Visual/Model

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = get_direction(delta)
	calculate_velocity(direction, delta)
	move_and_slide()

func get_direction(delta: float):
	var new_rotation = 0.0
	
	if Input.is_action_pressed("ui_left"):
		new_rotation += ROTATION_SPEED * delta
	if Input.is_action_pressed("ui_right"):
		new_rotation -= ROTATION_SPEED * delta
	if new_rotation != 0:
		print('    delta: %s' % delta)
		print('  degrees: %s' % new_rotation)
		print('  radians: %s' % deg_to_rad(new_rotation))
		rotate_y(deg_to_rad(new_rotation))

	# Handle Jump.
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	return direction

func calculate_velocity(direction: Vector3, delta: float):
	# GRAVITY
	if not is_on_floor() and gravity_toggle:
		velocity.y -= gravity * delta

	if direction:
		#rotation.y = atan2(direction.x, direction.z)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if velocity.length() == 0:
		state = 'idle'
	elif velocity.y < 0:
		state = 'fall'
	elif velocity.y > 0:
		state = 'jump'
	elif velocity.x + velocity.z != 0:
		state = 'run'
