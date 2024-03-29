extends CharacterBody3D

@export var NORMAL_SPEED = 6.5
@export var SPRINT_SPEED = 25
@export var JUMP_VELOCITY = 6.5
@export var WALL_JUMP_VELOCITY = 12
@export var WALL_JUMP_COUNTER = 4
@export var STAMINA = 100.0
@export var MOUSE_SENSITIVITY = 0.005
@export var MAX_STAMINA = 100.0
@onready var neck := $CameraRoot
@onready var cam := $CameraRoot/Camera3D
@onready var revolverAnim := $CameraRoot/Camera3D/plchld_revolver_better/AnimationPlayer
@onready var raycast := $CameraRoot/Camera3D/RayCast3D
@onready var raycastEnd := $CameraRoot/Camera3D/RayCastEnd

#CAM BOBBING FUNCTION WOOO
@export var BOB_FREQUENCY = 1.5
const BOB_AMPLITUDE = 0.08
var t_bob = 0.0

@onready var revolverBarrel := $CameraRoot/Camera3D/plchld_revolver_better/BarrelEnd

var proyectile #on ready for non hitscan weapons
var bulletTrail = load("res://Kleo Game Scenes/bullet_trail.tscn")
var instance

const BASE_FOV = 100 #base camera has 100° FOV
const FOV_MULTIPLIER = 1.01

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _unhandled_input(event): # Window Activity and Camera Movement
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"): # ui_cancel = esc key
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
			cam.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
			cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _ready():
	pass
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		if is_on_wall_only() and Input.is_action_just_pressed("jump") and WALL_JUMP_COUNTER != 0:
			velocity = get_wall_normal() * WALL_JUMP_VELOCITY
			velocity.y += JUMP_VELOCITY * 0.85
			WALL_JUMP_COUNTER = WALL_JUMP_COUNTER - 1
	
	# Handle jump.
	if is_on_floor():
		WALL_JUMP_COUNTER = 4
		if Input.is_action_pressed("jump"):
			velocity.y = JUMP_VELOCITY

	if not Input.is_action_pressed("sprint") && STAMINA < MAX_STAMINA && is_on_floor():
		STAMINA = STAMINA + 0.5
	if STAMINA > MAX_STAMINA:
		STAMINA = MAX_STAMINA
	var input_dir = Input.get_vector("moveLeft", "moveRight", "moveForward", "moveBack")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if is_on_floor():
			velocity.x = lerp(velocity.x, direction.x * 6.5, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * 6.5, delta * 7.0)
			if Input.is_action_pressed("sprint") && STAMINA > 0:
				velocity.x = lerp(velocity.x, direction.x * SPRINT_SPEED, delta * 3.5)
				velocity.z = lerp(velocity.z, direction.z * SPRINT_SPEED, delta * 3.5)
				STAMINA = STAMINA - 0.5
		else:
			velocity.x = lerp(velocity.x, direction.x * 13, delta * 1.5)
			velocity.z = lerp(velocity.z, direction.z * 13, delta * 1.5)
			if Input.is_action_pressed("sprint") && STAMINA > 0:
				velocity.x = lerp(velocity.x, direction.x * 1.5 * SPRINT_SPEED, delta * 0.5)
				velocity.z = lerp(velocity.z, direction.z * 1.5 * SPRINT_SPEED, delta * 0.5)
				STAMINA = STAMINA - 2.5
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, 0.35)
			velocity.z = move_toward(velocity.z, 0, 0.35)
	
	#headbob
	t_bob += delta * velocity.length() * float(is_on_floor())
	cam.transform.origin = headbob(t_bob)
	
	#GUN
	if Input.is_action_pressed("primaryFire"):
		shoot_hitscan()
	
	#FOV
	var velocityClamped = clamp(velocity.length(), 0.0, SPRINT_SPEED)
	var targetFov = BASE_FOV + (FOV_MULTIPLIER * velocityClamped)
	cam.fov = lerp(cam.fov, targetFov, delta * 8)
	
	move_and_slide()

func headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQUENCY) * BOB_AMPLITUDE
	pos.x = cos(time * BOB_FREQUENCY / 2) * BOB_AMPLITUDE
	return pos

func shoot_hitscan():
	if !revolverAnim.is_playing():
		revolverAnim.play("recoil")
		instance = bulletTrail.instantiate()
		if raycast.is_colliding():
			instance.init(revolverBarrel.global_position, raycast.get_collision_point())
			#instance.trigger_particle(raycast.get_collision_point(),revolverBarrel.global_position)
			#add a check for enemies
			#add a way to make bulletholes on surfaces
		else:
			instance.init(revolverBarrel.global_position, raycastEnd.global_position)
		get_parent().add_child(instance)
