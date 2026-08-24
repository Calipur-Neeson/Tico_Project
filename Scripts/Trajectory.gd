class_name Trajectory
extends Marker3D

@onready var camera: Camera3D = $"../SpringArm3D/Camera3D"
@onready var container: PlayerContainer = $"../Container"
@onready var drawDebug: MeshInstance3D = $MeshInstance3D
@onready var player: Node3D = get_parent()
@export var color: Color
@export var thickness: float = 5

const EPISILON: float = 0.00001
var gravity: float
var drag: float
var tStep: float = 0.05
var startPoint: Vector3
var isAim: bool = false

func _ready() -> void:
	gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	drag = ProjectSettings.get_setting("physics/3d/default_linear_damp")

func _physics_process(delta: float) -> void:
	if drawDebug.mesh is ImmediateMesh:
		drawDebug.mesh.clear_surfaces()
	if isAim:
		DrawAim()

func DrawLine(pointA: Vector3, pointB: Vector3, c: Color = color) -> void:
	if pointA.is_equal_approx(pointB):
		return
	if drawDebug.mesh is ImmediateMesh:
		drawDebug.mesh.surface_begin(Mesh.PRIMITIVE_LINES)
		drawDebug.mesh.surface_set_color(c)
		
		drawDebug.mesh.surface_add_vertex(pointA)
		drawDebug.mesh.surface_add_vertex(pointB)
		drawDebug.mesh.surface_end()

func DrawLineRelative(pointA: Vector3, pointB: Vector3, c: Color = color) -> void:
	DrawLine(pointA, pointA + pointB, c)

func DrawLineRelative_thick(pointA: Vector3, pointB: Vector3,thick: float = thickness, c: Color = color) -> void:
	pointB = pointA + pointB
	
	if pointA.is_equal_approx(pointB):
		return
	if drawDebug.mesh is ImmediateMesh:
		drawDebug.mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
		drawDebug.mesh.surface_set_color(c)
		
		var scaleFactor: float = 100.0
		
		var dir: Vector3 = pointA.direction_to(pointB)
		# Draw Cube Line
		var normal := Vector3(-dir.y, dir.x, 0).normalized() \
			if (abs(dir.x) + abs(dir.y) > EPISILON) \
			else Vector3(0, -dir.z, dir.y).normalized()
		normal *= thick / scaleFactor
		
		var vertices_order = [4, 5, 0, 1, 2, 5, 6, 4, 7, 0, 3, 2, 7, 6]
		var localB = pointB - pointA
		# Caculate line mesh at origin
		for v in range(14):
			var vertex = normal if \
				vertices_order[v] < 4 else \
				normal / 3.0 +localB
			var final_vert = vertex.rotated(dir,
				PI * (0.5 * (vertices_order[v] % 4) + 0.25))
			# Offset to real position
			final_vert += pointA
			drawDebug.mesh.surface_add_vertex(final_vert)
		drawDebug.mesh.surface_end()
	
func RayCastQuery(pointA: Vector3, pointB: Vector3) -> Dictionary:
	var spaceState = get_world_3d().direct_space_state

	var query = PhysicsRayQueryParameters3D.create(
		pointA,
		pointB,
		0xFFFFFFFF
	)

	query.hit_from_inside = false

	var result := spaceState.intersect_ray(query)

	if not result.is_empty():
		var localStart := drawDebug.to_local(pointA)
		var localHit := drawDebug.to_local(result.position)

		DrawLineRelative_thick(
			localStart,
			localHit - localStart,
			10,
			Color.PURPLE
		)

	return result

func DrawAim() -> void:
	var speed: float = 15.0

	var vel := -camera.global_transform.basis.z.normalized() * speed

	var lineStart: Vector3 = global_position

	for i in range(150):
		vel.y -= gravity * tStep

		vel *= clamp(1.0 - drag * tStep, 0.0, 1.0)

		var lineEnd := lineStart + vel * tStep

		var ray := RayCastQuery(lineStart, lineEnd)

		if not ray.is_empty():
			break

		DrawLineRelative_thick(
			drawDebug.to_local(lineStart),
			drawDebug.to_local(lineEnd) -
			drawDebug.to_local(lineStart)
		)

		lineStart = lineEnd
