class_name BasePlayerState
extends RefCounted

#Called when we first enter this state
func Enter(player: Player) -> void:
	pass
	
#Called when we exit this state
func Exit(player: Player) -> void:
	pass
	
func PreUpdate(player: Player) -> void:
	pass

#Called for every frame run in this state
func Update(player: Player, delta: float) -> void:
	pass
