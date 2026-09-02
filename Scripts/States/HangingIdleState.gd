class_name PlayerHangingIdleState
extends BasePlayerState

var normal :Vector3
var hitPoint: Vector3
var obstacleHight: float
var targetPointA: Vector3
var time: float

func Enter(player: Player) -> void:
	player.assuming_land_cast.enabled = false
	
	player.obstacle_cast.force_raycast_update()
	hitPoint = player.obstacle_cast.get_collision_point()
	player.obstacle_cast.enabled = false
	obstacleHight = hitPoint.y - player.global_position.y
	
	targetPointA = player.global_position + Vector3(0, obstacleHight - 1.8, 0)
	
	player.climb_normal_cast.enabled = true
	player.climb_normal_cast.force_raycast_update()
	player.climb_up_cast.enabled = true
	player.climb_up_cast.force_raycast_update()
	
	player.left_climb_cast.enabled = true
	player.right_climb_cast.enabled = true
	player.animation_tree.set("parameters/movement/transition_request", "hangIdleShort")
	
	
func PreUpdate(player: Player) -> void:
	if Input.is_action_just_pressed("Crouch"):
		player.island = true
		player.ChangeStateTo(PlayerState.HangingToFall)
	elif Input.is_action_just_pressed("Jump"):
		if player.GetMoveInput().z > 0.6:
			player.ChangeStateTo(PlayerState.Fall)
		elif player.climb_up_cast.is_colliding():
			player.ChangeStateTo(PlayerState.ClimbWall)
	
	elif player.shimmy_cast.position.x < 0 and player.left_climb_cast.is_colliding():
		player.ChangeStateTo(PlayerState.LeftShimmy)
	elif player.shimmy_cast.position.x > 0 and player.right_climb_cast.is_colliding():
		player.ChangeStateTo(PlayerState.RightShimmy)
	elif Input.is_action_just_pressed("Jump") and player.shimmy_cast.is_colliding():
		if Input.is_action_pressed("Move_Forward") or Input.is_action_pressed("Move_Left") or Input.is_action_pressed("Move_Right"):
			player.ChangeStateTo(PlayerState.HangingToJump)

func Update(player: Player, delta: float) -> void:
	player.shimmy_cast.position.x += player.GetMoveInput().x * 10.0 * delta
	player.shimmy_cast.position.y -= player.GetMoveInput().z * 10.0 * delta
	
	if abs(player.GetMoveInput().x) <= 0.3:
		player.shimmy_cast.position.x = 0
	if player.GetMoveInput().z == 0:
		player.shimmy_cast.position.y = 1.9
	
	player.shimmy_cast.position.x = clampf(player.shimmy_cast.position.x, -player.shimmyDis, player.shimmyDis)
	player.shimmy_cast.position.y = clamp(player.shimmy_cast.position.y, 2 - player.shimmyJumpDis, 1.9 + player.shimmyJumpDis)
	
	if Input.is_action_pressed("Move_Left") and player.shimmy_cast.is_colliding():
		player.left_ik.influence = 1
		player.left_hand_point.position = player.shimmy_cast.position
	else :
		player.left_ik.influence = 0
	if Input.is_action_pressed("Move_Right") and player.shimmy_cast.is_colliding():
		player.right_ik.influence = 1
		player.right_hand_point.position = player.shimmy_cast.position
	else :
		player.right_ik.influence = 0
	
	
	normal = player.climb_normal_cast.get_collision_normal()
	player.TurnTo(-normal)
	player.SmoothLerp(targetPointA,delta)
	
func Exit(player: Player) -> void:
	player.left_ik.influence = 0
	player.right_ik.influence = 0
	player.climb_normal_cast.enabled = false
	player.climb_up_cast.enabled = false
