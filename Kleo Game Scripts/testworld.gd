extends Node3D

@onready var player = $Character
@onready var oob = $out_of_bounds

func _physics_process(delta):
	get_tree().call_group("enemies", "update_target_location", player.global_transform.origin)
	if $music.playing == false: 
		$music.play()
	pass


func _on_out_of_bounds_body_entered(body):
	if body.is_in_group("player"):
		body.set_position(Vector3(0,0,0))
		print("Shit, looks like i forgot to fix that...")

func splat():
	player.stylebonus_splat()
