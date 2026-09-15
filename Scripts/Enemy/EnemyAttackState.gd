class_name EnemyAttackState
extends BaseEnemyState

func Enter(enemy: Enemy) -> void:
	enemy.hasTarget = false
	
func PreUpdate(enemy: Enemy) -> void:
	if enemy.player:
		var dis: float = enemy.position.distance_to(enemy.player.position)
		if dis >= 5:
			enemy.ChangeStateTo(enemy.enemyState.Idle)

func Update(enemy: Enemy, delta: float) -> void:
	if enemy.player:
		var direction: Vector3 = enemy.global_position.direction_to(enemy.player.global_position)
		enemy.TurnTo(direction, enemy.rotateSpeed)
	
		enemy.player.heatSystem.InterveneHeat(-enemy.damage, delta)

	
