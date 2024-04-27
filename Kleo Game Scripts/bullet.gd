extends Node3D

const SPEED = 100
@onready var mesh := $Cone
@onready var rayCastBullet := $RayCast3D
@onready var particleImpact := $GPUParticles3D
@onready var despawnTimer := $DespawnTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var delay = randf_range(0.0, 0.18)
	await get_tree().create_timer(delay).timeout
	despawn_timer()
	position += transform.basis * Vector3(0, 0, SPEED) * delta
	if rayCastBullet.is_colliding():
		mesh.visible = false
		particleImpact.emitting = true
		await get_tree().create_timer(1.0).timeout
		if rayCastBullet.get_collider().is_in_group("enemies"):
			rayCastBullet.get_collider().get_hit(0.4)
		queue_free()

func despawn_timer():
	await get_tree().create_timer(10.0).timeout
	queue_free()
