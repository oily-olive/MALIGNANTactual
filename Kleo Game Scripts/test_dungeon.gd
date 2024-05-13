extends Node3D

#@onready var player = $Character

func _physics_process(delta):
	#get_tree().call_group("enemies", "update_target_location", player.global_transform.origin)
	#if $music.playing == false: 
		#$music.play()
	pass

#
#func splat():
	#player.stylebonus_splat()


func _on_out_of_bounds_body_entered(body):
	if body.is_in_group("player"):
		body.set_position(Vector3(0,1,0))
		print("Shit, looks like i forgot to fix that...")
