extends BaseInteractable

@onready var shape_cast_3d: ShapeCast3D = $ShapeCast3D
var current_player: Player = null

func Interact(player: Player) -> void:
	print("Save")
	#TODO: save menu

func _physics_process(delta: float) -> void:
	if shape_cast_3d.is_colliding():
		var player = shape_cast_3d.get_collider(0) as Player
		current_player = player
		current_player.heatSystem.isDroping = false
	elif current_player != null and not shape_cast_3d.is_colliding():
		current_player.heatSystem.isDroping = true
		current_player = null
