class_name EnemyPatrolState
extends BaseEnemyState

var currentPointIndex: int = 0

func Enter(enemy: Enemy) -> void:
	enemy.moveSpeed = 2
	enemy.hasTarget = true
	var dis: float = INF
	for index in enemy.patrolPoints.size():
		var disToPoint = enemy.global_position.distance_to(enemy.patrolPoints[index].global_position)
		if disToPoint < dis:
			dis = disToPoint
			currentPointIndex = index
	enemy.targetPositon = enemy.patrolPoints[currentPointIndex].global_position

func PreUpdate(enemy: Enemy) -> void:
	if enemy.playerCast.is_colliding():
		enemy.player = enemy.playerCast.get_collider(0)
		if not enemy.ifThereIsWall(enemy.player.global_position):
			enemy.targetPositon = enemy.player.global_position
			enemy.ChangeStateTo(enemy.enemyState.Chase)
	
func Update(enemy: Enemy, delta: float) -> void:
	if enemy.navigation_agent_3d.is_target_reached():
		currentPointIndex += 1
		if currentPointIndex >= enemy.patrolPoints.size():
			currentPointIndex = 0
		enemy.targetPositon = enemy.patrolPoints[currentPointIndex].global_position
