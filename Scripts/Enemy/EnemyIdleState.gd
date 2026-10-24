class_name EnemyIdleState
extends BaseEnemyState

func Enter(enemy: Enemy) -> void:
	enemy.hasTarget = false

func PreUpdate(enemy: Enemy) -> void:
	if enemy.playerCast.is_colliding():
		enemy.player = enemy.playerCast.get_collider(0)
		if not enemy.ifThereIsWall(enemy.player.global_position):
			enemy.targetPositon = enemy.player.global_position
			enemy.ChangeStateTo(enemy.enemyState.Chase)
