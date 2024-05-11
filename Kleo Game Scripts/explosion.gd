extends Area3D

var despawn = 10.0
var actual_despawn

var damage_dealt

func _process(delta):
	actual_despawn = despawn + 10
	despawn -= 0.1
	if despawn < 0:
		f_despawn()

func create(damage):
	$CollisionShape3D.shape.set_radius(sqrt(sqrt(damage)))
	$MeshInstance3D.mesh.set_radius(sqrt(sqrt(damage)))
	$MeshInstance3D.mesh.set_height(2 * $MeshInstance3D.mesh.radius)
	damage_dealt = damage

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.get_hit_p(damage_dealt * 10)
	if body.is_in_group("enemies"):
		body.get_hit(damage_dealt)

func f_despawn():
	$CollisionShape3D.set_disabled(true)
	self.visible = false
	if actual_despawn < 0:
		queue_free()
