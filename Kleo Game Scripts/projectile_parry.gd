extends Area3D
var is_parryable

func change_direction(direction: Vector3, force: float, exploding: bool, parryable: bool):
	get_parent_node_3d().change_direction(direction, force, exploding, parryable)

func explode():
	get_parent_node_3d().explode()
	get_parent_node_3d().despawn()

func _process(delta):
	is_parryable = get_parent_node_3d().is_parryable
