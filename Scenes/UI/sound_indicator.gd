extends Node

@export var detection_distance: float = 20.0

@onready var images: Array[CanvasItem] = [
	$Silent,
	$Low,
	$Medium,
	$Loud
]


func _ready() -> void:
	set_enemy_distance(2.0)


func set_enemy_distance(distance: float) -> void:
	var level := clampf(
		1.0 - distance / detection_distance,
		0.0,
		1.0
	)

	var selected := 0  # Silent

	if level > 0.75:
		selected = 3    # Loud
	elif level > 0.50:
		selected = 2    # Medium
	elif level > 0.25:
		selected = 1    # Low

	for i in range(images.size()):
		images[i].visible = (i == selected)

	# देखिएको PNG का bars को shader चलाउने
	for image in images:
		var shader_material := image.material as ShaderMaterial
		if shader_material != null:
			shader_material.set_shader_parameter("proximity", level)


func _process(_delta: float) -> void:
	var player := get_tree().get_first_node_in_group("player") as Node3D
	if player == null:
		return

	var nearest_distance := detection_distance

	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy is Node3D:
			var distance := player.global_position.distance_to(
				enemy.global_position
			)
			nearest_distance = minf(nearest_distance, distance)

	set_enemy_distance(nearest_distance)
