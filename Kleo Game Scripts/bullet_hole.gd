extends Decal


# Called when the node enters the scene tree for the first time.
func _ready():
	var random_time = randf_range(-1.0, 1.0)
	await get_tree().create_timer(3 + random_time).timeout
	var fade = get_tree().create_tween()
	fade.tween_property(self, "modulate:a", 0, 0.75)
	await get_tree().create_timer(0.75).timeout
	queue_free()
