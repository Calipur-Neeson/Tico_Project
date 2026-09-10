class_name EnemyChaseState
extends BaseEnemyState

func Enter(enemy: Enemy) -> void:
	enemy.hasTarget = true
	
func PreUpdate(enemy: Enemy) -> void:
	if enemy.navigation_agent_3d.is_target_reached():
		enemy.ChangeStateTo(enemy.enemyState.Idle)
