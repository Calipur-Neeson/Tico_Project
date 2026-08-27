class_name PlayerVaultState
extends BasePlayerState

var hitPoint: Vector3
var playerFootPoint: Vector3
var obstacleHight: float

func Enter(player: Player) -> void:
	player.obstacle_cast.enabled = false
	
	hitPoint = player.obstacle_cast.get_collision_point()
	playerFootPoint = player.global_position - Vector3(0, 1.75/2, 0)
	
	obstacleHight = hitPoint.y - playerFootPoint.y
	if obstacleHight < 1.4:
		player.playerAnim.play("NewLib/VaultLow", player.BLEEND_SPEED)
