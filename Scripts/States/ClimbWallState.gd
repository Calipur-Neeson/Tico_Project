class_name PlayerClimbWallState
extends BasePlayerState

var hitPoint: Vector3
var playerFootPoint: Vector3
var obstacleHight: float
var targetPointA: Vector3
var targetPointB: Vector3
var targetPointC: Vector3

var time: float

func Enter(player: Player) -> void:
	player.assuming_land_cast.enabled = false
	
	player.obstacle_cast.force_raycast_update()
	hitPoint = player.obstacle_cast.get_collision_point()
	player.obstacle_cast.enabled = false
	
	playerFootPoint = player.global_position - Vector3(0, 1.75/2, 0)
	obstacleHight = hitPoint.y - playerFootPoint.y
	
	targetPointA = player.global_position + Vector3(0, obstacleHight - 1.9, 0)
	targetPointB = targetPointA + Vector3(0, 1.1, 0)
	targetPointC = targetPointB + Vector3(0, 0.8, 0) + player.global_basis.z * -0.5

	var right := player.global_basis.x.normalized()
	player.left_arm_target.global_position = hitPoint - right * 0.26 
	player.right_arm_target.global_position = hitPoint + right * 0.35
	
	player.playerAnim.play("NewLib/ClimbWall", player.BLEEND_SPEED)
	
func PreUpdate(player: Player) -> void:
	if not player.playerAnim.is_playing():
		player.ChangeStateTo(PlayerState.Idle)

func Update(player: Player, delta: float) -> void:
	time = player.playerAnim.current_animation_position
	if time <= 0.05:
		player.SmoothLerp(targetPointA, delta)
		player.left_ccdik_3d.influence = move_toward(player.left_ccdik_3d.influence, 0.5, delta * 8.0)
		player.right_ccdik_3d.influence = move_toward(player.right_ccdik_3d.influence, 0.5, delta * 8.0)
	elif time <= 0.59:
		player.SmoothLerp(targetPointB, delta)
	else :
		player.SmoothLerp(targetPointC, delta)
		player.right_ccdik_3d.influence = move_toward(player.right_ccdik_3d.influence, 0.0, delta * 8.0)
		player.left_ccdik_3d.influence = move_toward(player.left_ccdik_3d.influence, 0.0, delta * 8.0)
	
