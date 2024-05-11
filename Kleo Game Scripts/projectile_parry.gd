extends Area3D

func change_direction(direction: Vector3, force: float, exploding: bool):
	get_parent_node_3d().change_direction(direction, force, exploding)

func explode():
	get_parent_node_3d().explode()
