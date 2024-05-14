extends Node3D
class_name Spawner

@export var thing_to_spawn : PackedScene
@export var spawns_immediately : bool
var load_thing

signal spawn_signal()

func _ready():
	load_thing = thing_to_spawn.instantiate()
	connect("spawn_signal", spawn)
	if spawns_immediately:
		spawn()

func spawn():
	load_thing.global_position = self.global_position
	load_thing.global_rotation = self.global_rotation
	get_tree().current_scene.add_child(load_thing)
	queue_free()
