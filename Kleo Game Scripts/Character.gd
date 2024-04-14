extends CharacterBody3D

@export var SPEED_BOOST = 1.0
@export var NORMAL_SPEED = 6.5
@export var SPRINT_SPEED = 50.0/13.0
@export var JUMP_VELOCITY = 6.5
@export var WALL_JUMP_VELOCITY = 12.0
@export var WALL_JUMP_COUNTER = 4
@export var STAMINA = 100.0
@export var MOUSE_SENSITIVITY = 0.005
@export var MAX_STAMINA = 100.0
@export var MOVE_SPEED = 6.5
@export var CONCENTRATION = 0.0
@export var MAX_CONCENTRATION = 100.0
@export var STAMINA_REGEN_COOLDOWN = 1.0
@export var STAMINA_REGEN_COOLDOWN_MAX = 1.0
@export var HP = 100.0
@export var MAX_HP = 100.0
@export var MAX_OVERHEAL = 2.0 * MAX_HP
var WEAPON = 1
var BOOST_DURATION = 0.0
var db_firemode = 0
var shotAMMO = 5
var SCORE = 0
var STYLE = 0.0
var STYLE_TIMEOUT = 0.0
var hg = false
var djh = false
@onready var neck := $CameraRoot
@onready var cam := $CameraRoot/Camera3D
@onready var revolverAnim := $CameraRoot/Camera3D/plchld_revolver_better/AnimationPlayer
@onready var doublebarrelAnim := $CameraRoot/Camera3D/double_shotty/AnimationPlayer
@onready var shottyAnim := $CameraRoot/Camera3D/new_shotgun/AnimationPlayer
@onready var raycast := $CameraRoot/Camera3D/RayCast3D
@onready var raycastEnd := $CameraRoot/Camera3D/RayCastEnd
@onready var stepsound := $walk_sound
@onready var gun1 := $CameraRoot/Camera3D/plchld_revolver_better
@onready var gun2 := $CameraRoot/Camera3D/double_shotty
@onready var gun3 := $CameraRoot/Camera3D/new_shotgun
@onready var ch := $CameraRoot2D/ui_container_center/crosshair

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
			print("fuck you i removed the wall jump because i was losing my goddamn mind")

	# UI
	$CameraRoot2D/ui_container_bottomleft/StaminaLabel.text = "STAMINA: " + str(int(STAMINA))
	$CameraRoot2D/ui_container_bottomleft/HPLabel.text = "HP: " + str(int(HP))

	# Handle jump.
	if is_on_floor():
		WALL_JUMP_COUNTER = 4
		if Input.is_action_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			if Input.is_action_pressed("sprint"):
				STAMINA = STAMINA - 25


	#STAMINA
	if not Input.is_action_pressed("sprint") && STAMINA_REGEN_COOLDOWN == STAMINA_REGEN_COOLDOWN_MAX && STAMINA < MAX_STAMINA && is_on_floor():
		STAMINA = STAMINA + 0.75
	if STAMINA > MAX_STAMINA:
		STAMINA = MAX_STAMINA
	if STAMINA < 0:
		STAMINA = 0
	if STAMINA_REGEN_COOLDOWN < STAMINA_REGEN_COOLDOWN_MAX && not Input.is_action_pressed("sprint"):
		STAMINA_REGEN_COOLDOWN = STAMINA_REGEN_COOLDOWN + 0.025
	if Input.is_action_pressed("sprint") or not is_on_floor():
		STAMINA_REGEN_COOLDOWN = 0
	if STAMINA_REGEN_COOLDOWN > STAMINA_REGEN_COOLDOWN_MAX:
		STAMINA_REGEN_COOLDOWN = STAMINA_REGEN_COOLDOWN_MAX
	
	
	if BOOST_DURATION == 0.0:
		SPEED_BOOST = 1.0
		
	if BOOST_DURATION > 0.0:
		BOOST_DURATION = BOOST_DURATION - 0.01
		
	if BOOST_DURATION < 0.0:
		BOOST_DURATION = 0.0
	
	
	var input_dir = Input.get_vector("moveLeft", "moveRight", "moveForward", "moveBack")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if is_on_floor():
			velocity.x = lerp(velocity.x, direction.x * (MOVE_SPEED * SPEED_BOOST), delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * (MOVE_SPEED * SPEED_BOOST), delta * 7.0)
			#if stepsound.playing == false:
				#stepsound.play()
			if Input.is_action_pressed("sprint") && STAMINA > 0:
				velocity.x = lerp(velocity.x, direction.x * (SPRINT_SPEED * (MOVE_SPEED * SPEED_BOOST)), delta * 3.5)
				velocity.z = lerp(velocity.z, direction.z * (SPRINT_SPEED * (MOVE_SPEED * SPEED_BOOST)), delta * 3.5)
				STAMINA = STAMINA - 0.5
		else:
			velocity.x = lerp(velocity.x, direction.x * (MOVE_SPEED * SPEED_BOOST) * 2, delta * 2.25)
			velocity.z = lerp(velocity.z, direction.z * (MOVE_SPEED * SPEED_BOOST) * 2, delta * 2.25)
			if Input.is_action_pressed("sprint") && STAMINA > 0:
				velocity.x = lerp(velocity.x, direction.x * ((MOVE_SPEED * SPEED_BOOST) * (13.0 / 4.0)) * SPRINT_SPEED, delta * 0.75)
				velocity.z = lerp(velocity.z, direction.z * ((MOVE_SPEED * SPEED_BOOST) * (13.0 / 4.0)) * SPRINT_SPEED, delta * 0.75)
				
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, 0.35)
			velocity.z = move_toward(velocity.z, 0, 0.35)
	
	#headbob
	t_bob += delta * velocity.length() * float(is_on_floor())
	cam.transform.origin = headbob(t_bob)
	
	#weapon handling
	if WEAPON > 3:
		WEAPON = 1
	if WEAPON < 1:
		WEAPON = 3
	if Input.is_action_just_pressed("weaponScrollUp"):
		WEAPON = WEAPON - 1
	if Input.is_action_just_pressed("weaponScrollDown"):
		WEAPON = WEAPON + 1
	if shotAMMO == 0:
		reload_revshotgun()
	if WEAPON == 1:
		ch.frame = 0
		gun1.visible = true
		gun2.visible = false
		gun3.visible = false
	elif WEAPON == 2:
		ch.frame = 1
		gun1.visible = false
		gun2.visible = true
		gun3.visible = false
	elif WEAPON == 3:
		ch.frame = 5
		gun1.visible = false
		gun2.visible = false
		gun3.visible = true
	
	if Input.is_action_pressed("primaryFire"):
		if WEAPON == 1:
			shoot_revolver()
		if WEAPON == 2:
			shoot_doublebarrel()
		if WEAPON == 3:
			shoot_revshotgun()
	
	if Input.is_action_pressed("secondaryFire"):
		if WEAPON == 1:
			pass
		if WEAPON == 2:
			dbshotgun_switch()
		if WEAPON == 3:
			if shotAMMO != 5:
				reload_revshotgun()
	
	#FOV
	
	var velocityClamped = clamp(velocity.length(), 0.0, SPRINT_SPEED * MOVE_SPEED * 100000)
	$CameraRoot2D/ui_container_bottomright/SpeedLabel.text = "SPEED: " + str(int(velocityClamped))
	var targetFov = BASE_FOV + (FOV_MULTIPLIER * velocityClamped * 0.75)
	cam.fov = lerp(cam.fov, targetFov, delta * 8)
	
	move_and_slide()
	
	#concentration
	if CONCENTRATION > MAX_CONCENTRATION:
		CONCENTRATION = MAX_CONCENTRATION
	if CONCENTRATION < 0.0:
		CONCENTRATION = 0.0
	
	#style
	if STYLE_TIMEOUT < 0:
		STYLE_TIMEOUT = 0
		
	if STYLE_TIMEOUT > 0:
		STYLE_TIMEOUT = STYLE_TIMEOUT - 0.1
	
	if STYLE_TIMEOUT == 0:
		SCORE = SCORE + int(STYLE)
		CONCENTRATION = CONCENTRATION + (STYLE / 10.0)
		STYLE = 0
	
	$CameraRoot2D/ui_container_topright/Style.text = "STYLE: " + str(int(STYLE))
	
	styleb_speed()

func headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQUENCY) * BOB_AMPLITUDE
	pos.x = cos(time * BOB_FREQUENCY / 2) * BOB_AMPLITUDE
	return pos

func shoot_revolver():
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
		
func shoot_doublebarrel():
	if !doublebarrelAnim.is_playing():
		doublebarrelAnim.play("recoil and reload")
		if db_firemode == 0:
			var gun_direction = (neck.transform.basis * Vector3(1, 1, 1)).normalized()
			var newvelocity = lerp(velocity, gun_direction * 13, 1)
			velocity = newvelocity + velocity
		else:
			pass
		
func dbshotgun_switch():
	if !doublebarrelAnim.is_playing():
		doublebarrelAnim.play("reload")
		if db_firemode == 0:
			db_firemode = 1
		else:
			db_firemode = 0
			
func shoot_revshotgun():
	if shotAMMO != 0:
		if !shottyAnim.is_playing():
			shottyAnim.play("recoil")
			shotAMMO = shotAMMO - 1
	else:
		pass

func reload_revshotgun():
	if !shottyAnim.is_playing():
		shottyAnim.play("reload")
		if shotAMMO > 0:
			BOOST_DURATION = 2.5
			SPEED_BOOST = 1.5
		shotAMMO = 5
		
func st():
	STYLE_TIMEOUT = 20.0
func styleb_speed():
	var velocityClamped = clamp(velocity.length(), 0.0, SPRINT_SPEED * MOVE_SPEED * 100000)
	if velocityClamped >= 45 and djh == false:
		hg = true
	if hg == true:
		STYLE = STYLE + 50
		st()
		djh = true
		hg = false
	if velocityClamped < 30:
		djh = false
