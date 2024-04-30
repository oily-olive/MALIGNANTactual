extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var hit_check = $RayCast3D
@onready var look_anchor = $Node3D
@onready var slef = $"."
@export var SPEED = 10.0
const MAX_HEALTH = 1.0
var HEALTH
var player
var attack_cooldown = 10.0
var is_stunned = false
@export var player_path : NodePath

func _ready():
	HEALTH = MAX_HEALTH
	player = get_node(player_path)

func _physics_process(delta):
	death_check()
	if HEALTH <= 0:
		pass
	else:
		var current_location = global_transform.origin
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		
		if attack_cooldown == 10.0:
			nav_agent.set_velocity(new_velocity)
			
		#look_at(Vector3((next_location.x - current_location.x) * velocity.x, look_anchor.global_position.y, (next_location.z - current_location.z) * velocity.z))
		look_at(next_location)
		
		
		if attack_cooldown < 0.0:
			attack_cooldown = 0.0
			
		if attack_cooldown > 10.0:
			attack_cooldown = 10.0
		
		if attack_cooldown < 10.0:
			attack_cooldown += 0.1
		if is_stunned == true:
			pass
		else:
			if hit_check.is_colliding():
				if hit_check.get_collider().is_in_group("player") and attack_cooldown == 10:
					attack_initiate()
			if hit_check.is_colliding() and attack_cooldown >= 9.0 and attack_cooldown <= 9.1:
				if hit_check.get_collider().is_in_group("player"):
					hit_check.get_collider().get_hit_p(10.0)

func update_target_location(target_location):
	nav_agent.target_position = target_location
	
func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if attack_cooldown == 10.0:
		velocity = velocity.move_toward(safe_velocity, .25)
	move_and_slide()

func get_hit(damage):
	is_stunned = true
	HEALTH -= damage
	await get_tree().create_timer(1.25).timeout
	is_stunned = false

func death_check():
	if HEALTH <= 0.0 - MAX_HEALTH:
		print("gibbed")
		slef.visible = false
		await get_tree().create_timer(1).timeout
		queue_free()
	elif HEALTH < 0.0:
		slef.visible = false
		await get_tree().create_timer(1).timout
		queue_free()
	else:
		pass

func attack_initiate():
	if attack_cooldown == 10.0:
		attack_cooldown = 0.0
