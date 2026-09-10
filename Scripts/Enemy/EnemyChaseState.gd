class_name EnemyChaseState
extends BaseEnemyState

func Enter(enemy: Enemy) -> void:
	enemy.moveSpeed = 4
	enemy.hasTarget = true
	
func PreUpdate(enemy: Enemy) -> void:
	if enemy.navigation_agent_3d.is_target_reached():
		enemy.ChangeStateTo(enemy.enemyState.Idle)

func Update(enemy: Enemy, delta: float) -> void:
	if enemy.playerCast.is_colliding():
		for i: int in enemy.playerCast.get_collision_count():
			var col = enemy.playerCast.get_collider(i)
			if col is Player:
				enemy.targetPositon = col.global_position
