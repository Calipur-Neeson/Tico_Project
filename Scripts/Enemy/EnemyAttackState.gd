class_name EnemyAttackState
extends BaseEnemyState

var time: float

func Enter(enemy: Enemy) -> void:
	time = 0
	
func PreUpdate(enemy: Enemy) -> void:
	if time > 1:
		enemy.ChangeStateTo(enemy.enemyState.Idle)

func Update(enemy: Enemy, delta: float) -> void:
	time += delta
