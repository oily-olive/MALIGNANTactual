extends Node3D
class_name Spawner

@export var thing_to_spawn : PackedScene
@export var spawns_immediately : bool
@export var add_to_scene : bool
@export var Node_to_inherit_from : Node3D
var load_thing

signal spawn_signal()

func _ready():
	connect("spawn_signal", spawn)
	if Node_to_inherit_from == null:
		Node_to_inherit_from = self
	if spawns_immediately:
		spawn()

func spawn():
	load_thing = thing_to_spawn.instantiate()
	load_thing.position = Node_to_inherit_from.global_position
	load_thing.rotation = Node_to_inherit_from.global_rotation
	if add_to_scene: #if true, adds the slelected thing as a direct child of the current scene. if false, adds it as a child of the parent of the spanwer
		get_tree().current_scene.add_child.call_deferred(load_thing)
	else:
		get_parent().add_child.call_deferred(load_thing)
