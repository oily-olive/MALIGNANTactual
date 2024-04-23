extends Node3D

const SPEED = 150.0
@onready var mesh := $Cone
@onready var rayCastBullet := $RayCast3D
@onready var particleImpact := $GPUParticles3D
@onready var despawnTimer := $DespawnTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.basis * Vector3(0, 0, SPEED) * delta
	if rayCastBullet.is_colliding():
		mesh.visible = false
		particleImpact.emitting = true
		await get_tree().create_timer(1.0).timeout
		queue_free()

func _on_timer_timeout():
	queue_free()
