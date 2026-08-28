class_name PlayerHangingIdleState
extends BasePlayerState

var normal :Vector3
var hitPoint: Vector3
var playerFootPoint: Vector3
var obstacleHight: float
var targetPointA: Vector3
var time: float

func Enter(player: Player) -> void:
	player.assuming_land_cast.enabled = false
	
	player.obstacle_cast.force_raycast_update()
	hitPoint = player.obstacle_cast.get_collision_point()
	player.obstacle_cast.enabled = false
	
	playerFootPoint = player.global_position - Vector3(0, 1.75/2, 0)
	obstacleHight = hitPoint.y - playerFootPoint.y
	
	targetPointA = player.global_position + Vector3(0, obstacleHight - 1.9, 0)
	
	player.position = targetPointA

	var right := player.global_basis.x.normalized()
	player.left_arm_target.global_position = hitPoint - right * 0.3
	player.right_arm_target.global_position = hitPoint + right * 0.3
	
	player.playerAnim.play("NewLib/ClimbWall", player.BLEEND_SPEED)
	
	#hitPoint = player.climbable_cast.get_collision_point()
	#normal = player.climbable_cast.get_collision_normal()
	
	if player.floor_cast.is_colliding():
		player.playerAnim.play("NewLib/HangingIdle_short", player.BLEEND_SPEED)
	else:	
		player.playerAnim.play("NewLib/HangingIdle", player.BLEEND_SPEED)
	
	var move: Vector3 = hitPoint - player.hand_pivot.global_position
	
func PreUpdate(player: Player) -> void:
	if Input.is_action_just_pressed("Crouch"):
		player.island = true
		player.ChangeStateTo(PlayerState.Fall)
	if player.left_climb_cast.is_colliding() and Input.is_action_pressed("Move_Left"):
		player.ChangeStateTo(PlayerState.LeftShimmy)
	elif player.right_climb_cast.is_colliding() and Input.is_action_pressed("Move_Right"):
		player.ChangeStateTo(PlayerState.RightShimmy)
	elif Input.is_action_just_pressed("Jump") and not player.ceiling_cast.is_colliding():
		player.ChangeStateTo(PlayerState.ClimbWall)
	elif player.left_turn_climb_cast.is_colliding() and not player.left_climb_cast.is_colliding() and Input.is_action_pressed("Move_Left"):
		player.ChangeStateTo(PlayerState.TurnLeftShimmy)
	elif player.right_turn_climb_cast.is_colliding() and not player.right_climb_cast.is_colliding() and Input.is_action_pressed("Move_Right"):
		player.ChangeStateTo(PlayerState.TurnRightShimmy)

func Update(player: Player, delta: float) -> void:
	player.TurnTo(-normal)
	
	player.left_ccdik_3d.influence = move_toward(player.left_ccdik_3d.influence, 0.2, delta * 8.0)
	player.right_ccdik_3d.influence = move_toward(player.right_ccdik_3d.influence, 0.2, delta * 8.0)
	
