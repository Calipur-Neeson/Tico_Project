class_name EnemyIdleState
extends BaseEnemyState

func Enter(enemy: Enemy) -> void:
	enemy.hasTarget = false

func PreUpdate(enemy: Enemy) -> void:
	if enemy.player != null and not enemy.ifThereIsWall(enemy.player.global_position):
		enemy.targetPositon = enemy.player.global_position
		enemy.ChangeStateTo(enemy.enemyState.Chase)
