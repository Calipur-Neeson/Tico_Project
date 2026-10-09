class_name EnemyAttackState
extends BaseEnemyState

var distance: float

func Enter(enemy: Enemy) -> void:
	enemy.beam.visible = true
	enemy.hasTarget = false
	
func PreUpdate(enemy: Enemy) -> void:
	if enemy.player:
		
		if distance > enemy.attackRange:
			enemy.beam.visible = false
			enemy.ChangeStateTo(enemy.enemyState.Idle)

func Update(enemy: Enemy, delta: float) -> void:
	if enemy.player:
		var direction: Vector3 = enemy.global_position.direction_to(enemy.player.global_position + enemy.player.basis.y * 1)
		enemy.TurnTo(direction, enemy.rotateSpeed)
		
		enemy.player.heatSystem.InterveneHeat(-enemy.damage, delta)
		
		#Show Beam
		distance = enemy.position.distance_to(enemy.player.position)
		
		if enemy.beam.mesh is CylinderMesh:
			enemy.beam.mesh.height = distance
			enemy.beam.global_position = enemy.global_position + direction * (distance / 2)
			enemy.beam.global_basis.y = direction
		
