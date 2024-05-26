extends Node3D

var player : Node3D
@onready var oob = $out_of_bounds

func _ready():
	await get_tree().create_timer(.1).timeout
	for node in get_children():
		if node.is_in_group("player"):
			player = node

func _physics_process(delta):
	#if $music.playing == false: 
		#$music.play()
	pass


func _on_out_of_bounds_body_entered(body):
	if body.is_in_group("player"):
		body.set_position(Vector3(0,5,0))
		print("Shit, looks like i forgot to fix that...")

func splat():
	player.stylebonus_splat()
