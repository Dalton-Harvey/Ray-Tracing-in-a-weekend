extends MeshInstance3D

@export var radius: float = 0.5
@export var color: Color = Color(1,0,0)

func _ready():
	set_radius(radius)

func set_radius(new_radius:float) -> void:
	radius = new_radius
	self.scale = Vector3(new_radius, new_radius, new_radius)
