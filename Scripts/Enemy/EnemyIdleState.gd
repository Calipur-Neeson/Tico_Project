class_name EnemyIdleState
extends BaseEnemyState

func Enter(enemy: Enemy) -> void:
	enemy.hasTarget = false

func PreUpdate(enemy: Enemy) -> void:
	if enemy.playerCast.is_colliding():
		for i: int in enemy.playerCast.get_collision_count():
			var col = enemy.playerCast.get_collider(i)
			if col is Player:
				enemy.targetPositon = col.global_position
				enemy.ChangeStateTo(enemy.enemyState.Chase)
