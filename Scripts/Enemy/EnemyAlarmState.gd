class_name EnemyAlarmState
extends BaseEnemyState

func Enter(enemy: Enemy) -> void:
	enemy.moveSpeed = 2
	enemy.hasTarget = true
	
func PreUpdate(enemy: Enemy) -> void:
	if enemy.navigation_agent_3d.is_target_reached():
		enemy.ChangeStateTo(enemy.enemyState.Idle)
	if enemy.playerCast.is_colliding():
		enemy.player = enemy.playerCast.get_collider(0)
		if not enemy.ifThereIsWall(enemy.player.global_position):
			enemy.targetPositon = enemy.player.global_position
			enemy.ChangeStateTo(enemy.enemyState.Chase)
