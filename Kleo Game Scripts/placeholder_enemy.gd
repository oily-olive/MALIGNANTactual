extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var look_anchor = $Node3D
@onready var hit_anchor = $Node3D2
@onready var collision_detect = $RayCast3D
@onready var world = self.get_parent()
@export var SPEED = 10.0
const MAX_HEALTH = 1.0
var HEALTH
var attack_cooldown = 5.0
var is_stunned = false
var hit = load("res://Kleo Game Scenes/hit_detect.tscn")
var hit_l
var is_dead = false
var splatted = false

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
		
		if attack_cooldown == 5.0:
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

func update_target_location(target_location):
	nav_agent.target_position = target_location
	
func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if is_dead == true:
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

func attack_initiate():
	if attack_cooldown == 5.0:
		attack_cooldown = 0.0
	await get_tree().create_timer(0.5).timeout
	hit_l = hit.instantiate()
	hit_l.position = hit_anchor.global_position
	hit_l.transform.basis = hit_anchor.global_transform.basis
	get_parent().add_child(hit_l)
	


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
	if not is_on_floor():
		velocity = Vector3(direction.x * 40, direction.y * 40, direction.z * 40)
	else:
		velocity = Vector3(direction.x * 40, direction.y * 40, direction.z * 40) / 4
