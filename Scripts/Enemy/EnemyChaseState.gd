class_name EnemyChaseState
extends BaseEnemyState


func Enter(enemy: Enemy) -> void:
	enemy.moveSpeed = 4
	enemy.hasTarget = true
	Bgm.OnEnemyPursue(1)
	
func PreUpdate(enemy: Enemy) -> void:
	if enemy.navigation_agent_3d.is_target_reached():
		enemy.ChangeStateTo(enemy.enemyState.Patrol)
		Bgm.OnEnemyPursue(-1)
	
	elif enemy.hit_box.is_colliding():
		enemy.ChangeStateTo(enemy.enemyState.Attack)

func Update(enemy: Enemy, delta: float) -> void:
	if enemy.player != null:
		enemy.targetPositon = enemy.player.global_position
