class_name EnemyIdleState
extends BaseEnemyState

func Enter(enemy: Enemy) -> void:
	enemy.hasTarget = false
