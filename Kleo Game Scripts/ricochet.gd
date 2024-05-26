extends RayCast3D

var target: Node3D
var raycast: RayCast3D
var previous_target: Node3D
var bounces: int
var already_spawned = false

@onready var new_cast = load("res://Kleo Game Scenes/ricochet.tscn")
@onready var bullet_trail = load("res://Kleo Game Scenes/bullet_trail.tscn")

func _ready():
	for obj in get_tree().current_scene.get_children():
		if obj.is_in_group("enemies"):
			if !obj.is_dead and obj != previous_target:
				if target != null:
					if (target.global_position + raycast.get_collision_point()) > (obj.global_position + raycast.get_collision_point()):
						target = obj.head
				else:
					target = obj.head
	if target != null:
		look_at(target.global_position)
	else:
		look_at(raycast.position.bounce(raycast.get_collision_normal()))
	await get_tree().create_timer(0.05).timeout
	exist()
		
func create(parent_raycast: RayCast3D, old_target: Node3D, times_to_bounce: int):
	raycast = parent_raycast
	previous_target = old_target
	bounces = times_to_bounce

func exist():
	var load_trail = bullet_trail.instantiate()
	if is_colliding():
		if get_collider().is_in_group("enemies"):
			get_collider().get_hit(abs(6 - bounces) + 1)
		elif get_collider().is_in_group("projectiles"):
			get_collider().explode()
		
		if bounces > 1:
			var load_cast = new_cast.instantiate()
			load_cast.create(self, target, bounces - 1)
			if get_collider().is_in_group("enemies") or get_collider().is_in_group("projectiles"):
				load_cast.position = get_collider().global_position
			else:
				load_cast.position = get_collision_point()
			get_parent().add_child(load_cast)
		
		load_trail.init(self.global_position, self.get_collision_point())
	else:
		load_trail.init(self.global_position, $end.global_position)
	get_parent().add_child(load_trail)
	queue_free()
