extends Node3D
class_name Spawner

@export var thing_to_spawn : PackedScene
@export var spawns_immediately : bool
var load_thing

signal spawn_signal()

func _ready():
	connect("spawn_signal", spawn)
	if spawns_immediately:
		spawn()

func spawn():
	load_thing = thing_to_spawn.instantiate()
	load_thing.position = self.global_position
	load_thing.rotation = self.global_rotation
	get_tree().current_scene.add_child.call_deferred(load_thing)
