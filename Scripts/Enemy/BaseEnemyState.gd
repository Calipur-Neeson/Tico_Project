class_name BaseEnemyState
extends RefCounted


#Called when we first enter this state
func Enter(enemy: Enemy) -> void:
	pass
	
#Called when we exit this state
func Exit(enemy: Enemy) -> void:
	pass
	
func PreUpdate(enemy: Enemy) -> void:
	pass

#Called for every frame run in this state
func Update(enemy: Enemy, delta: float) -> void:
	pass
