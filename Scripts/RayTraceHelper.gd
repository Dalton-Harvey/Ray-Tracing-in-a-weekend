extends Node3D

@export var quad: MeshInstance3D
@export var camera: Camera3D
@export var focal_length = 1;
var mat = ShaderMaterial
var spheres: Array[SphereData] = []
var dynamic = false

func _ready():
	mat = quad.get_active_material(0)
	_init_scene_uniforms()
	_init_viewport_dimensions()


func _process(_delta):
	if dynamic:
		_update_scene_uniforms()

func _init_scene_uniforms():
	for object in get_tree().get_nodes_in_group("Scene_Objects"):
		var curr = SphereData.new()
		curr.center = object.global_transform.origin
		curr.radius = object.scale.x * 0.5
		spheres.append(curr)
	pass

func _update_scene_uniforms():
	mat.set_shader_parameter("cam_origin", camera.global_transform.origin)

func _init_viewport_dimensions():
	var screen_size = get_viewport().size
	var aspect_ratio = float(screen_size.x) / float(screen_size.y)

	var viewport_height = 2.0 * focal_length * tan(deg_to_rad($Camera3D.fov) / 2.0)
	var viewport_width = viewport_height * aspect_ratio

	var viewport_u = Vector3(viewport_width,0,0)
	var viewport_v = Vector3(0,-viewport_height,0)

	var pixel_delta_u = viewport_u / screen_size.x
	var pixel_delta_v = viewport_v / screen_size.y
	
	var viewport_upper_left = $Camera3D.global_transform.origin - Vector3(0,0,focal_length) - viewport_u/2 - viewport_v/2
	var pixel00_loc = viewport_upper_left + 0.5 * (pixel_delta_u + pixel_delta_v)

	mat.set_shader_parameter("aspect_ratio", aspect_ratio)
	mat.set_shader_parameter("screen_size", screen_size)
	mat.set_shader_parameter("viewport_height", viewport_height)
	mat.set_shader_parameter("viewport_width", viewport_width)
	mat.set_shader_parameter("pixel_delta_u", pixel_delta_u)
	mat.set_shader_parameter("pixel_delta_v", pixel_delta_v)
	mat.set_shader_parameter("viewport_upper_left", viewport_upper_left)
	mat.set_shader_parameter("pixel00_loc", pixel00_loc)
	mat.set_shader_parameter("cam_origin", $Camera3D.global_transform.origin)
