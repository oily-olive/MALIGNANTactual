extends Node3D

@export var DEFAULT_HP := 20
@export var DAMAGE := 1

signal hit(dam)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_shot():
	emit_signal("hit", DAMAGE)
