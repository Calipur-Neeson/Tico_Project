extends BaseInteractable

@export_range(5 , 20) var healSpeed

var current_player: Player = null

func Interact(player: Player) -> void:
	print("Save")
	QuickSave.save_var("PlayerPosition", player.position)
	print(player.position)
	#TODO: save menu

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		body.heatSystem.dropSpeed -= healSpeed 

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Player:
		body.heatSystem.dropSpeed += healSpeed
