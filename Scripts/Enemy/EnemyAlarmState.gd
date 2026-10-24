class_name EnemyAlarmState
extends BaseEnemyState

var timer: float = 0
var isArrived: bool

func Enter(enemy: Enemy) -> void:
	timer = 0
	isArrived = false
	enemy.moveSpeed = 2
	enemy.hasTarget = true
	Bgm.OnEnemyAlarm(1)
	
func PreUpdate(enemy: Enemy) -> void:
	if enemy.navigation_agent_3d.is_target_reached():
		isArrived = true
		if timer >= 2:
			enemy.ChangeStateTo(enemy.enemyState.Patrol)
	if enemy.playerCast.is_colliding():
		enemy.player = enemy.playerCast.get_collider(0)
		if not enemy.ifThereIsWall(enemy.player.global_position):
			enemy.targetPositon = enemy.player.global_position
			enemy.ChangeStateTo(enemy.enemyState.Chase)

func Update(enemy: Enemy, delta: float) -> void:
	if isArrived:
		timer += delta
	
func Exit(enemy: Enemy) -> void:
	Bgm.OnEnemyAlarm(-1)
