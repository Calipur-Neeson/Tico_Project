extends Control

@export var player: Player
@export var camera: Camera3D 
@export var enemyCast: Area3D
@export var castCollision: CollisionShape3D
@export var radar_range: float = 8.0
@export var marker_radius: float = 4.0
@export var enemy_color: Color = Color.RED

@onready var indicator: SoundIndicator = $"../.."

var enemies: Array[Enemy] = []
var radar_center: Vector2 = size / 2.0
var radar_radius: float = min(size.x, size.y) / 2.0
var max_dot_distance: float = radar_radius - marker_radius
var minDis: float = 10

func _ready() -> void:
	enemyCast.body_entered.connect(OnEntered)
	enemyCast.body_exited.connect(OnExited)
	var sphere := castCollision.shape as SphereShape3D
	sphere.radius = radar_range

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	minDis = 10
	if enemies.is_empty():
		indicator.shader_material.set_shader_parameter("hasEnemy", false)
		return
	
	# Camera forward projected onto the horizontal plane
	var forward: Vector3 = -camera.global_basis.z
	forward.y = 0.0
	if forward.length_squared() < 0.0001:
		return
	forward = forward.normalized()
	
	# Camera right direction on the horizontal plane
	var right: Vector3 = forward.cross(Vector3.UP).normalized()
	
	for enemy in enemies:
		var offset: Vector3 = (enemy.global_position - player.global_position)
		var distance: float = offset.length()
		if distance <= minDis:
			minDis = distance
		
		# Convert world direction to camera-relative coordinates
		var radar_x: float = offset.dot(right)
		var radar_y: float = -offset.dot(forward)
		var radar_position := Vector2(radar_x, radar_y)
		# Map 10 metres to the edge of the radar
		radar_position = (radar_position / radar_range * max_dot_distance)
		
		draw_circle(radar_center + radar_position, marker_radius, enemy_color)
	
	indicator.shader_material.set_shader_parameter("hasEnemy", true)
	indicator.shader_material.set_shader_parameter("influence", minDis)

func OnEntered(body: Node3D) -> void:
	if body is Enemy:
		enemies.append(body)

func OnExited(body: Node3D) -> void:
	if body is Enemy:
		enemies.erase(body)
