extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var look_anchor = $Node3D
@onready var hit_anchor = $Node3D2
@onready var collision_detect = $RayCast3D
@onready var world = self.get_parent()
@onready var head = $CollisionShape3D2
@export var SPEED = 10.0
const MAX_HEALTH = 5.0
var HEALTH
var attack_cooldown = 0.0
var is_stunned = false
var hit = load("res://Kleo Game Scenes/projectile.tscn")
var hit_l
var is_dead = false
var direction
var player: Node3D

func _ready():
	HEALTH = MAX_HEALTH
	

@warning_ignore("unused_parameter")
func _physics_process(delta):
	if is_dead == true:
		pass
	else:
		death_check()
		direction = ($Node3D3.global_position - $Node3D3/Node3D2.global_position).normalized() * -1
		@warning_ignore("unused_variable")
		var current_location = global_transform.origin
		var next_location = nav_agent.get_target_position()
		
		if attack_cooldown == 15.0:
			attack_initiate()
			
			
		$Node3D3.look_at(next_location)
		
		
		if attack_cooldown < 0.0:
			attack_cooldown = 0.0
			
		if attack_cooldown > 15.0:
			attack_cooldown = 15.0
		
		if attack_cooldown < 15.0:
			attack_cooldown += 0.1
		if is_stunned == true:
			pass
		

func _process(delta):
	if player == null:
		for node in world.get_children():
			if node.is_in_group("player"):
				player = node
	if player != null:
		var offset = randf_range(-0.6, 0.6)
		await get_tree().create_timer(0+offset).timeout
		nav_agent.target_position = player.global_position

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
	if attack_cooldown == 15.0:
		attack_cooldown = 0.0
	hit_l = hit.instantiate()
	hit_l.change_direction(direction, 15, false, true)
	hit_l.position = $Node3D3/Node3D2.global_position
	get_parent().add_child(hit_l)
	

		
func die():
	$CollisionShape3D.set_disabled(true)
	$CollisionShape3D2.set_disabled(true)
	self.visible = false
	is_dead = true
	await get_tree().create_timer(5).timeout
	queue_free()
	
func get_launched_by_punch(direction):
	pass
