extends BaseInteractable

@onready var shape_cast_3d: ShapeCast3D = $ShapeCast3D

@export_range(5 , 20) var healSpeed

var current_player: Player = null

func Interact(player: Player) -> void:
	print("Save")
	QuickSave.save_var("PlayerPosition", player.position)
	print(player.position)
	#TODO: save menu

func _physics_process(delta: float) -> void:
	if shape_cast_3d.is_colliding() and current_player == null:
		var player = shape_cast_3d.get_collider(0) as Player
		current_player = player
	
	if current_player != null:
		current_player.heatSystem.InterveneHeat(healSpeed, delta)
		
	elif current_player != null and not shape_cast_3d.is_colliding():
		current_player.heatSystem.isIntervene = false
		current_player = null
