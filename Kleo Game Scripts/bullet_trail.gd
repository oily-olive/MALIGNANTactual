extends MeshInstance3D

@onready var gunImpact = $HitImpact
var alpha = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var duplicate_material = material_override.duplicate()
	material_override = duplicate_material
	var fade = get_tree().create_tween()
	fade.tween_property(self, "modulate:a", 0, 0.15)
	await get_tree().create_timer(0.15).timeout
	queue_free()

func init(posBarrel, posTarget):
	var draw_mesh = ImmediateMesh.new()
	mesh = draw_mesh
	draw_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material_override)
	draw_mesh.surface_add_vertex(posBarrel)
	draw_mesh.surface_add_vertex(posTarget)
	draw_mesh.surface_end()


func trigger_particle(pos, barrelPosition): #reminder to check the enemy scan
	$HitImpact.set_position(pos)
	$HitImpact.look_at(barrelPosition)
	$HitImpact.emitting = true

