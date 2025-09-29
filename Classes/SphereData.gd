class_name SphereData

var center: Vector3
var radius: float
var color: Color

func _init(_center: Vector3 = Vector3(), _radius: float = 1.0, _color: Color = Color(1,1,1)):
    center = _center
    radius = _radius
    color = _color
