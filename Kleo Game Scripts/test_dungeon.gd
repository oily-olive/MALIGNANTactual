extends Node3D

@onready var dungeon_generator = $DungeonGenerator
#@onready var player = $Character
var finished : bool
var stop_adding_walls : bool

func _physics_process(delta):
	#get_tree().call_group("enemies", "update_target_location", player.global_transform.origin)
	#if $music.playing == false: 
		#$music.play()
	if dungeon_generator.stage == 5 and !stop_adding_walls:
		if finished == true:
			for room in dungeon_generator._rooms:
				for door in room.get_doors():
					if door.get_room_leads_to() == null and door.optional:
						for wall in door.door_node.get_children():
							if wall.is_in_group("spawner"):
								wall.spawn()
								stop_adding_walls = true
		else:
			finished = true
	pass

#
#func splat():
	#player.stylebonus_splat()


func _on_out_of_bounds_body_entered(body):
	if body.is_in_group("player"):
		body.set_position(Vector3(0,1,0))
		print("Shit, looks like i forgot to fix that...")
