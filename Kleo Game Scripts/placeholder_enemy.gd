extends CharacterBody3D
class_name Enemy

@onready var nav_agent = $NavigationAgent3D
@onready var look_anchor = $Node3D
@onready var hit_anchor = $Node3D2
@onready var collision_detect = $RayCast3D
@onready var world = self.get_parent()
@onready var head = $CollisionShape3D
@onready var attack_hitbox = $attack_hitbox as Area3D
@export var SPEED = 10.0
@export var ATTACK_DAMAGE: float = 1
@export var MAX_HEALTH = 1.0
var HEALTH
var attack_cooldown = 5.0
var is_stunned = false
var is_dead = false
var splatted = false
var player: Player
@export var moves: bool

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	HEALTH = MAX_HEALTH
	

func _physics_process(delta):
	if is_dead == true:
		pass
	else:
		death_check()
		
		if not is_on_floor():
			var velocityInt = abs(velocity.x) + abs(velocity.y) + abs(velocity.z)
			if collision_detect.is_colliding() and velocityInt >= 40.0 and splatted == false:
				splatter(velocityInt/30)
			velocity.y -= gravity * delta
		var current_location = global_transform.origin
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		
		if attack_cooldown == 5.0 and moves:
			nav_agent.set_velocity(new_velocity)
			
		#look_at(Vector3((next_location.x - current_location.x) * velocity.x, look_anchor.global_position.y, (next_location.z - current_location.z) * velocity.z))
		look_at(Vector3(next_location.x, look_anchor.global_position.y, next_location.z))
		
		
		if attack_cooldown < 0.0:
			attack_cooldown = 0.0
			
		if attack_cooldown > 5.0:
			attack_cooldown = 5.0
		
		if attack_cooldown < 5.0:
			attack_cooldown += 0.1
		if is_stunned == true:
			pass
		
		collision_detect.set_target_position(velocity.normalized() * 2)

func _process(delta):
	if player == null:
		for node in world.get_children():
			if node.is_in_group("player"):
				player = node
	if player != null:
		var offset = randf_range(-0.6, 0.6)
		await get_tree().create_timer(0+offset).timeout
		nav_agent.target_position = player.global_position
	
func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if is_dead == true or !moves:
		pass
	else:
		if attack_cooldown == 5.0:
			velocity = velocity.move_toward(safe_velocity, .25)
		move_and_slide()

func get_hit(damage):
	is_stunned = true
	HEALTH -= damage
	await get_tree().create_timer(1.25).timeout
	is_stunned = false

func death_check():
	if HEALTH <= 0.0:
		die()
	if HEALTH <= 0.0 - MAX_HEALTH:
		print("gibbed")
		die()
	else:
		pass
var attacking: bool = false
var attack_interrupted: bool = false
func attack_initiate():
	attack_cooldown = 0.0
	await get_tree().create_timer(0.3).timeout
	attacking = true
	await get_tree().create_timer(0.2).timeout
	if !attack_interrupted:
		for body in attack_hitbox.get_overlapping_bodies():
			if body == player:
				body.get_hit_p(ATTACK_DAMAGE)
	attacking = false
	attack_interrupted = false


func _on_navigation_agent_3d_target_reached():
	if attack_cooldown == 5.0 and is_dead == false:
		attack_initiate()
		
func die():
	$CollisionShape3D.set_disabled(true)
	self.visible = false
	is_dead = true
	await get_tree().create_timer(5).timeout
	queue_free()

func get_launched_by_slam():
	velocity.y += 20.0

func splatter(damage):
	splatted = true
	get_hit(damage)
	world.splat()
	
func get_launched_by_punch(direction):
	if moves:
		if not is_on_floor():
			velocity = Vector3(direction.x * 40, direction.y * 40, direction.z * 40)
		else:
			velocity = Vector3(direction.x * 40, direction.y * 40, direction.z * 40) / 4

func parry():
	if attacking:
		attack_interrupted = true
		player.hitstop_standard(0.25)
		player.stylebonus_parry()
		get_hit(3)
