extends CharacterBody3D

var explodes: bool
var damage: float
var just_spawned = true
@onready var explosion = load("res://Kleo Game Scenes/explosion.tscn")

func _process(delta):
	if is_on_wall():
		if explodes:
			explode()
		despawn()
		
	if just_spawned == true:
		spawn_timer()
	
	damage = (abs(velocity.x) + abs(velocity.y) + abs(velocity.z)) * (2.0/3.0)
		
	move_and_slide()
	
func change_direction(direction: Vector3, force: float, exploding: bool):
	velocity = direction * force
	explodes = exploding
	just_spawned = true
	
func despawn():
	$CollisionShape3D.set_disabled(true)
	self.visible = false
	await get_tree().create_timer(0.1).timeout
	$Area3D.monitoring = false
	$Area3D.monitorable = false
	await get_tree().create_timer(.5).timeout
	queue_free()

func spawn_timer():
	await get_tree().create_timer(0.25).timeout
	just_spawned = false

func _on_area_3d_body_entered(body):
	if !just_spawned:
		if body.is_in_group("player"):
			body.get_hit_p(damage)
		if body.is_in_group("enemies"):
			body.get_hit(damage/10)
		if explodes:
			explode()
		despawn()

func explode():
	var explosion_l = explosion.instantiate()
	explosion_l.create(damage)
	explosion_l.position = global_position
	get_parent().add_child(explosion_l)
	explodes = false
