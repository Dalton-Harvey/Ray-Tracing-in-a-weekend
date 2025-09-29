extends Camera3D

@export var distance_in_front: float = 1.0
var quad: MeshInstance3D

func _ready():
	# Assume the quad is a child of this camera
	quad = $RenderQuad
	_update_quad_scale_and_position()

func _process(_delta):
	_update_quad_scale_and_position()

func _update_quad_scale_and_position():
	# Move the quad in front of the camera
	quad.transform.origin = Vector3(0, 0, -distance_in_front)

	# Rotate quad to match camera orientation
	quad.transform.basis = Basis()  # identity, because it's a child of the camera
	
	# Calculate scale to fill the screen
	var fov_rad = deg_to_rad(fov)  # use the camera's fov
	var height = 2.0 * distance_in_front * tan(fov_rad / 2.0)
	var viewport_size = get_viewport().get_visible_rect().size
	var aspect = viewport_size.x / viewport_size.y
	var width = height * aspect
	
	quad.scale = Vector3(width, height, 1)
