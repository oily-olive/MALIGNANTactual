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
var COMBO = 0
var speedCashout = false
var topSpeedChecker = false
@onready var neck := $CameraRoot
@onready var cam := $CameraRoot/Camera3D
@onready var revolverAnim := $CameraRoot/Camera3D/plchld_revolver_better/AnimationPlayer
@onready var doublebarrelAnim := $CameraRoot/Camera3D/double_shotty/AnimationPlayer
@onready var shottyAnim := $CameraRoot/Camera3D/new_shotgun/AnimationPlayer
@onready var raycast_r := $CameraRoot/Camera3D/hitscan_01
@onready var raycast_db_u := $CameraRoot/Camera3D/hitscan_06
@onready var raycast_db_l := $CameraRoot/Camera3D/hitscan_07
@onready var raycast_melee := $CameraRoot/Camera3D/hitscan_08
@onready var raycastEnd_r := $CameraRoot/Camera3D/hitscan_end_01
@onready var raycastEnd_db_u := $CameraRoot/Camera3D/hitscan_end_06
@onready var raycastEnd_db_l := $CameraRoot/Camera3D/hitscan_end_07
@onready var cross_c := $CameraRoot/Camera3D/hitscan_01/crossover_check
@onready var stepsound := $walk_sound
@onready var gun1 := $CameraRoot/Camera3D/plchld_revolver_better
@onready var gun2 := $CameraRoot/Camera3D/double_shotty
@onready var gun3 := $CameraRoot/Camera3D/new_shotgun
@onready var ch := $CameraRoot2D/ui_container_center/crosshair

# bullet variables
var bulletStandard := load("res://Kleo Game Scenes/bullet.tscn")
var instanceBullet_s
var instanceBullet_ns1
var instanceBullet_ns2
var instanceBullet_ns3
var instanceBullet_ns4
var instanceBullet_ns11
var instanceBullet_ns21
var instanceBullet_ns31
var instanceBullet_ns41
#@onready var bl := %CameraRoot2D/ui_container_topright/BonusesLabel
@onready var cl := %ComboLabel

#CAM BOBBING FUNCTION WOOO
@export var BOB_FREQUENCY = 1.5
const BOB_AMPLITUDE = 0.08
var t_bob = 0.0

@onready var revolverBarrel := $CameraRoot/Camera3D/plchld_revolver_better/BarrelEnd
@onready var dbBarrel_u := $CameraRoot/Camera3D/double_shotty/Armature/Skeleton3D/Cylinder_001/Cylinder_001/upper_barrel_end
@onready var dbBarrel_u1 := $CameraRoot/Camera3D/double_shotty/Armature/Skeleton3D/Cylinder_001/Cylinder_001/upper_barrel_end/shotgun_spread/s
@onready var dbBarrel_u2 := $CameraRoot/Camera3D/double_shotty/Armature/Skeleton3D/Cylinder_001/Cylinder_001/upper_barrel_end/shotgun_spread/d
@onready var dbBarrel_u3 := $CameraRoot/Camera3D/double_shotty/Armature/Skeleton3D/Cylinder_001/Cylinder_001/upper_barrel_end/shotgun_spread/w
@onready var dbBarrel_u4 := $CameraRoot/Camera3D/double_shotty/Armature/Skeleton3D/Cylinder_001/Cylinder_001/upper_barrel_end/shotgun_spread/a
@onready var dbBarrel_u5 := $CameraRoot/Camera3D/double_shotty/Armature/Skeleton3D/Cylinder_001/Cylinder_001/upper_barrel_end/shotgun_spread/s2
@onready var dbBarrel_u6 := $CameraRoot/Camera3D/double_shotty/Armature/Skeleton3D/Cylinder_001/Cylinder_001/upper_barrel_end/shotgun_spread/d2
@onready var dbBarrel_u7 := $CameraRoot/Camera3D/double_shotty/Armature/Skeleton3D/Cylinder_001/Cylinder_001/upper_barrel_end/shotgun_spread/w2
@onready var dbBarrel_u8 := $CameraRoot/Camera3D/double_shotty/Armature/Skeleton3D/Cylinder_001/Cylinder_001/upper_barrel_end/shotgun_spread/a2
@onready var dbBarrel_l := $CameraRoot/Camera3D/double_shotty/Armature/Skeleton3D/Cylinder_001/Cylinder_001/lower_barrel_end
@onready var dbBarrel_l1 := $CameraRoot/Camera3D/double_shotty/Armature/Skeleton3D/Cylinder_001/Cylinder_001/lower_barrel_end/shotgun_spread/s
@onready var dbBarrel_l2 := $CameraRoot/Camera3D/double_shotty/Armature/Skeleton3D/Cylinder_001/Cylinder_001/lower_barrel_end/shotgun_spread/d
@onready var dbBarrel_l3 := $CameraRoot/Camera3D/double_shotty/Armature/Skeleton3D/Cylinder_001/Cylinder_001/lower_barrel_end/shotgun_spread/w
@onready var dbBarrel_l4 := $CameraRoot/Camera3D/double_shotty/Armature/Skeleton3D/Cylinder_001/Cylinder_001/lower_barrel_end/shotgun_spread/a
@onready var dbBarrel_l5 := $CameraRoot/Camera3D/double_shotty/Armature/Skeleton3D/Cylinder_001/Cylinder_001/lower_barrel_end/shotgun_spread/s2
@onready var dbBarrel_l6 := $CameraRoot/Camera3D/double_shotty/Armature/Skeleton3D/Cylinder_001/Cylinder_001/lower_barrel_end/shotgun_spread/d2
@onready var dbBarrel_l7 := $CameraRoot/Camera3D/double_shotty/Armature/Skeleton3D/Cylinder_001/Cylinder_001/lower_barrel_end/shotgun_spread/w2
@onready var dbBarrel_l8 := $CameraRoot/Camera3D/double_shotty/Armature/Skeleton3D/Cylinder_001/Cylinder_001/lower_barrel_end/shotgun_spread/a2
@onready var rsBarrel := $CameraRoot/Camera3D/new_shotgun/Cube_002/barrel_end
@onready var rsBarrel1 := $CameraRoot/Camera3D/new_shotgun/Cube_002/shotgun_spread/s
@onready var rsBarrel2 := $CameraRoot/Camera3D/new_shotgun/Cube_002/shotgun_spread/d
@onready var rsBarrel3 := $CameraRoot/Camera3D/new_shotgun/Cube_002/shotgun_spread/w
@onready var rsBarrel4 := $CameraRoot/Camera3D/new_shotgun/Cube_002/shotgun_spread/a
@onready var rsBarrel11 := $CameraRoot/Camera3D/new_shotgun/Cube_002/shotgun_spread/s2
@onready var rsBarrel21 := $CameraRoot/Camera3D/new_shotgun/Cube_002/shotgun_spread/d2
@onready var rsBarrel31 := $CameraRoot/Camera3D/new_shotgun/Cube_002/shotgun_spread/w2
@onready var rsBarrel41 := $CameraRoot/Camera3D/new_shotgun/Cube_002/shotgun_spread/a2

var proyectile #on ready for non hitscan weapons
var bulletTrail = load("res://Kleo Game Scenes/bullet_trail.tscn")
var instanceRaycast_r
var instanceRaycast_db_u
var instanceRaycast_db_l
var instanceRaycast_rs

const BASE_FOV = 100 #base camera has 100° FOV
const FOV_MULTIPLIER = 1.01

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func hitstop_standard():
	$hitstop_sound.play()
	Engine.time_scale = 0
	await get_tree().create_timer(0.25, true, false, true).timeout
	Engine.time_scale = 1

func _unhandled_input(event): # Window Activity and Camera Movement
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"): # ui_cancel = esc key
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var time_s = Engine.time_scale
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * MOUSE_SENSITIVITY * time_s)
			cam.rotate_x(-event.relative.y * MOUSE_SENSITIVITY * time_s)
			cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _ready():
	pass
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	var velocityClamped = clamp(velocity.length(), 0.0, SPRINT_SPEED * MOVE_SPEED * 100000)
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
			if stepsound.playing == false and (velocity.x != 0 or velocity.z != 0):
				stepsound.pitch_scale = velocityClamped/10
				stepsound.play()
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
	
	if Input.is_action_just_pressed("tertiaryFire"):
		#hitstop_standard()
		pass
	
	#FOV
	

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
		SCORE = SCORE + int(STYLE * COMBO)
		CONCENTRATION = CONCENTRATION + (STYLE / 10.0)
		STYLE = 0
		COMBO = 0
	
	$CameraRoot2D/ui_container_topright/StyleLabel.text = "STYLE: " + str(int(STYLE))
	$CameraRoot2D/ui_container_topleft/ScoreLabel.text = str(SCORE)
	if COMBO >= 2:
		cl.visible = true
	else:
		cl.visible = false
	cl.text = "COMBO x" + str(COMBO)
	
	stylebonus_speed()

func headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQUENCY) * BOB_AMPLITUDE
	pos.x = cos(time * BOB_FREQUENCY / 2) * BOB_AMPLITUDE
	return pos

func shoot_revolver():
	if !revolverAnim.is_playing():
		revolverAnim.play("recoil")
		#instanceBullet = bulletStandard.instantiate()
		#instanceBullet.position = revolverBarrel.global_position
		#instanceBullet.transform.basis = revolverBarrel.global_transform.basis
		instanceRaycast_r = bulletTrail.instantiate()
		if raycast_r.is_colliding():
			instanceRaycast_r.init(revolverBarrel.global_position, raycast_r.get_collision_point())
			#instance.trigger_particle(raycast.get_collision_point(),revolverBarrel.global_position)
			#add a check for enemies
			#add a way to make bulletholes on surfaces
		else:
			instanceRaycast_r.init(revolverBarrel.global_position, raycastEnd_r.global_position)
		#get_parent().add_child(instanceBullet)
		get_parent().add_child(instanceRaycast_r)
		
		
#behold, the folly of man.
func shoot_doublebarrel():
	if !doublebarrelAnim.is_playing():
		doublebarrelAnim.play("recoil and reload")
		if db_firemode == 0:
			var basis_x = cam.rotation_degrees.x
			var vector_y = (-1 * (basis_x * (10.0 / 9.0))) / 100.0
			$CameraRoot2D/ui_container_bottomright/SpeedLabel.text = str(vector_y)
			var vector_z = abs((((abs(basis_x)) * (10.0 / 9.0)) / 100.0) - 1)
			var gun_direction = neck.transform.basis * Vector3(0,vector_y,vector_z)
			var newvelocity = lerp(velocity, gun_direction * 13, 1)
			velocity += newvelocity
			if true:
				instanceBullet_s = bulletStandard.instantiate()
				instanceBullet_s.position = dbBarrel_u.global_position
				instanceBullet_s.transform.basis = dbBarrel_u.global_transform.basis
				instanceBullet_ns1 = bulletStandard.instantiate()
				instanceBullet_ns1.position = dbBarrel_u.global_position
				instanceBullet_ns1.transform.basis = dbBarrel_u1.global_transform.basis
				instanceBullet_ns2 = bulletStandard.instantiate()
				instanceBullet_ns2.position = dbBarrel_u.global_position
				instanceBullet_ns2.transform.basis = dbBarrel_u2.global_transform.basis
				instanceBullet_ns3 = bulletStandard.instantiate()
				instanceBullet_ns3.position = dbBarrel_u.global_position
				instanceBullet_ns3.transform.basis = dbBarrel_u3.global_transform.basis
				instanceBullet_ns4 = bulletStandard.instantiate()
				instanceBullet_ns4.position = dbBarrel_u.global_position
				instanceBullet_ns4.transform.basis = dbBarrel_u4.global_transform.basis
				instanceBullet_ns11 = bulletStandard.instantiate()
				instanceBullet_ns11.position = dbBarrel_u.global_position
				instanceBullet_ns11.transform.basis = dbBarrel_u5.global_transform.basis
				instanceBullet_ns21 = bulletStandard.instantiate()
				instanceBullet_ns21.position = dbBarrel_u.global_position
				instanceBullet_ns21.transform.basis = dbBarrel_u6.global_transform.basis
				instanceBullet_ns31 = bulletStandard.instantiate()
				instanceBullet_ns31.position = dbBarrel_u.global_position
				instanceBullet_ns31.transform.basis = dbBarrel_u7.global_transform.basis
				instanceBullet_ns41 = bulletStandard.instantiate()
				instanceBullet_ns41.position = dbBarrel_u.global_position
				instanceBullet_ns41.transform.basis = dbBarrel_u8.global_transform.basis
				get_parent().add_child(instanceBullet_s)
				get_parent().add_child(instanceBullet_ns1)
				get_parent().add_child(instanceBullet_ns2)
				get_parent().add_child(instanceBullet_ns3)
				get_parent().add_child(instanceBullet_ns4)
				get_parent().add_child(instanceBullet_ns11)
				get_parent().add_child(instanceBullet_ns21)
				get_parent().add_child(instanceBullet_ns31)
				get_parent().add_child(instanceBullet_ns41)

			if true:
				instanceBullet_s = bulletStandard.instantiate()
				instanceBullet_s.position = dbBarrel_l.global_position
				instanceBullet_s.transform.basis = dbBarrel_l.global_transform.basis
				instanceBullet_ns1 = bulletStandard.instantiate()
				instanceBullet_ns1.position = dbBarrel_l.global_position
				instanceBullet_ns1.transform.basis = dbBarrel_l1.global_transform.basis
				instanceBullet_ns2 = bulletStandard.instantiate()
				instanceBullet_ns2.position = dbBarrel_l.global_position
				instanceBullet_ns2.transform.basis = dbBarrel_l2.global_transform.basis
				instanceBullet_ns3 = bulletStandard.instantiate()
				instanceBullet_ns3.position = dbBarrel_l.global_position
				instanceBullet_ns3.transform.basis = dbBarrel_l3.global_transform.basis
				instanceBullet_ns4 = bulletStandard.instantiate()
				instanceBullet_ns4.position = dbBarrel_l.global_position
				instanceBullet_ns4.transform.basis = dbBarrel_l4.global_transform.basis
				instanceBullet_ns11 = bulletStandard.instantiate()
				instanceBullet_ns11.position = dbBarrel_l.global_position
				instanceBullet_ns11.transform.basis = dbBarrel_l5.global_transform.basis
				instanceBullet_ns21 = bulletStandard.instantiate()
				instanceBullet_ns21.position = dbBarrel_l.global_position
				instanceBullet_ns21.transform.basis = dbBarrel_l6.global_transform.basis
				instanceBullet_ns31 = bulletStandard.instantiate()
				instanceBullet_ns31.position = dbBarrel_l.global_position
				instanceBullet_ns31.transform.basis = dbBarrel_l7.global_transform.basis
				instanceBullet_ns41 = bulletStandard.instantiate()
				instanceBullet_ns41.position = dbBarrel_l.global_position
				instanceBullet_ns41.transform.basis = dbBarrel_l8.global_transform.basis
				get_parent().add_child(instanceBullet_s)
				get_parent().add_child(instanceBullet_ns1)
				get_parent().add_child(instanceBullet_ns2)
				get_parent().add_child(instanceBullet_ns3)
				get_parent().add_child(instanceBullet_ns4)
				get_parent().add_child(instanceBullet_ns11)
				get_parent().add_child(instanceBullet_ns21)
				get_parent().add_child(instanceBullet_ns31)
				get_parent().add_child(instanceBullet_ns41)
			
		else:
			if cross_c.is_colliding():
				hitstop_standard()
			instanceRaycast_db_u = bulletTrail.instantiate()
			instanceRaycast_db_l = bulletTrail.instantiate()
			if raycast_db_u.is_colliding():
				instanceRaycast_db_u.init(dbBarrel_u.global_position, raycast_db_u.get_collision_point())
			else:
				instanceRaycast_db_u.init(dbBarrel_u.global_position, raycastEnd_db_u.global_position)
			if raycast_db_l.is_colliding():
				instanceRaycast_db_l.init(dbBarrel_l.global_position, raycast_db_l.get_collision_point())
			else:
				instanceRaycast_db_l.init(dbBarrel_l.global_position, raycastEnd_db_l.global_position)
			get_parent().add_child(instanceRaycast_db_u)
			get_parent().add_child(instanceRaycast_db_l)
		
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
			instanceRaycast_rs = bulletTrail.instantiate()
			if shotAMMO == 0:
				if raycast_r.is_colliding():
					instanceRaycast_rs.init(rsBarrel.global_position, raycast_r.get_collision_point())
				else:
					instanceRaycast_rs.init(rsBarrel.global_position, raycastEnd_r.global_position)
				get_parent().add_child(instanceRaycast_rs)
			else:
				instanceBullet_s = bulletStandard.instantiate()
				instanceBullet_s.position = rsBarrel.global_position
				instanceBullet_s.transform.basis = rsBarrel.global_transform.basis
				instanceBullet_ns1 = bulletStandard.instantiate()
				instanceBullet_ns1.position = rsBarrel.global_position
				instanceBullet_ns1.transform.basis = rsBarrel1.global_transform.basis
				instanceBullet_ns2 = bulletStandard.instantiate()
				instanceBullet_ns2.position = rsBarrel.global_position
				instanceBullet_ns2.transform.basis = rsBarrel2.global_transform.basis
				instanceBullet_ns3 = bulletStandard.instantiate()
				instanceBullet_ns3.position = rsBarrel.global_position
				instanceBullet_ns3.transform.basis = rsBarrel3.global_transform.basis
				instanceBullet_ns4 = bulletStandard.instantiate()
				instanceBullet_ns4.position = rsBarrel.global_position
				instanceBullet_ns4.transform.basis = rsBarrel4.global_transform.basis
				instanceBullet_ns11 = bulletStandard.instantiate()
				instanceBullet_ns11.position = rsBarrel.global_position
				instanceBullet_ns11.transform.basis = rsBarrel11.global_transform.basis
				instanceBullet_ns21 = bulletStandard.instantiate()
				instanceBullet_ns21.position = rsBarrel.global_position
				instanceBullet_ns21.transform.basis = rsBarrel21.global_transform.basis
				instanceBullet_ns31 = bulletStandard.instantiate()
				instanceBullet_ns31.position = rsBarrel.global_position
				instanceBullet_ns31.transform.basis = rsBarrel31.global_transform.basis
				instanceBullet_ns41 = bulletStandard.instantiate()
				instanceBullet_ns41.position = rsBarrel.global_position
				instanceBullet_ns41.transform.basis = rsBarrel41.global_transform.basis
				get_parent().add_child(instanceBullet_s)
				get_parent().add_child(instanceBullet_ns1)
				get_parent().add_child(instanceBullet_ns2)
				get_parent().add_child(instanceBullet_ns3)
				get_parent().add_child(instanceBullet_ns4)
				get_parent().add_child(instanceBullet_ns11)
				get_parent().add_child(instanceBullet_ns21)
				get_parent().add_child(instanceBullet_ns31)
				get_parent().add_child(instanceBullet_ns41)
	else:
		pass

func reload_revshotgun():
	if !shottyAnim.is_playing():
		shottyAnim.play("reload")
		if shotAMMO > 0:
			BOOST_DURATION = 2.5
			SPEED_BOOST = 1.5
		shotAMMO = 5
		
func style_timeout():
	STYLE_TIMEOUT = STYLE_TIMEOUT + (20.0 / (COMBO))
func stylebonus_speed():
	var velocityClamped = clamp(velocity.length(), 0.0, SPRINT_SPEED * MOVE_SPEED * 100000)
	if velocityClamped >= 40 and topSpeedChecker == false: # djh
		speedCashout = true # hg
	if speedCashout == true:
		STYLE += 100 # Same thing as STYLE = STYLE + 100 but shorter lmao
		COMBO += 1 # Same thing as above
		style_timeout()
		#bl.text = str(bl.text) + ("+ SPEED DEMON")
		topSpeedChecker = true
		speedCashout = false
	if velocityClamped < 30:
		topSpeedChecker = false
