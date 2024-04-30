extends RayCast3D

func _process(delta):
	await get_tree().create_timer(0.25).timeout
	if self.is_colliding() and self.get_collider().is_in_group("player"):
		self.get_collider().get_hit_p(10.0)
		queue_free()
	else:
		queue_free()
