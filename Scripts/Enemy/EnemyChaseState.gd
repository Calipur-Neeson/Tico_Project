class_name EnemyChaseState
extends BaseEnemyState


func Enter(enemy: Enemy) -> void:
	enemy.moveSpeed = 4
	enemy.hasTarget = true
	
func PreUpdate(enemy: Enemy) -> void:
	if enemy.navigation_agent_3d.is_target_reached():
		enemy.ChangeStateTo(enemy.enemyState.Idle)
	
	elif enemy.hit_box.is_colliding():
		enemy.ChangeStateTo(enemy.enemyState.Attack)

func Update(enemy: Enemy, delta: float) -> void:
	if enemy.player != null:
		enemy.targetPositon = enemy.player.global_position
