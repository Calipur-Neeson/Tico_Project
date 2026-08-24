class_name BaseProjectile
extends Node3D

@onready var shape_cast_3d: ShapeCast3D = $ShapeCast3D

@export var speed: float = 15.0
var gravity: float
var velocity: Vector3 

func _ready() -> void:
	var camera := get_viewport().get_camera_3d()
	var direction := -camera.global_transform.basis.z.normalized()
	velocity = direction * speed
	gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	

func _physics_process(delta: float) -> void:
	if shape_cast_3d.is_colliding():
		return
	velocity.y -= gravity * delta
	position += velocity * delta
