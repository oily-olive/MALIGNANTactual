extends Area3D

var despawn = 10.0
var actual_despawn

var damage_dealt
var stop_lerping = false

func _process(delta):
	actual_despawn = despawn + 10
	despawn -= 0.1
	if $MeshInstance3D.mesh.radius >= $CollisionShape3D.shape.radius:
		$MeshInstance3D.mesh.material.albedo_color = lerp($MeshInstance3D.mesh.material.albedo_color, Color("ffff0000"), delta * 2)
	if $MeshInstance3D.mesh.radius < $CollisionShape3D.shape.radius:
		$MeshInstance3D.mesh.radius += 0.25
	$MeshInstance3D.mesh.height = $MeshInstance3D.mesh.radius * 2
	if despawn < 0:
		f_despawn()

func create(damage):
	$CollisionShape3D.shape.set_radius(sqrt(sqrt(damage)))
	$MeshInstance3D.mesh.material.albedo_color = Color("ffff00ff")
	$MeshInstance3D.mesh.radius = 0
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
