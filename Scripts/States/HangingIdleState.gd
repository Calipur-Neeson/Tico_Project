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
	
	player.animation_tree.set("parameters/movement/transition_request", "hangIdleShort")
	
	
func PreUpdate(player: Player) -> void:
	if Input.is_action_just_pressed("Crouch"):
		player.island = true
		player.ChangeStateTo(PlayerState.HangingToFall)
	
	if player.shimmy_cast.is_colliding():
		var hitPoint: Vector3 = player.shimmy_cast.get_collision_point()
		var dis: float = player.position.distance_to(hitPoint)
	
		if Input.is_action_pressed("Move_Left") and player.shimmy_cast.position.y < 2.1:
			player.ChangeStateTo(PlayerState.LeftShimmy)
		elif Input.is_action_pressed("Move_Right") and player.shimmy_cast.position.y < 2.1:
			player.ChangeStateTo(PlayerState.RightShimmy)
		elif Input.is_action_just_pressed("Jump") and not player.climb_up_cast.is_colliding():
			player.ChangeStateTo(PlayerState.ClimbWall)
		elif Input.is_action_just_pressed("Jump"):
			if Input.is_action_pressed("Move_Left") or Input.is_action_pressed("Move_Right") or Input.is_action_pressed("Move_Forward"):
				player.ChangeStateTo(PlayerState.HangingToJump)
	

func Update(player: Player, delta: float) -> void:
	if Input.is_action_pressed("Move_Left"):
		player.shimmy_cast.position.x -= 10 * delta
	elif Input.is_action_pressed("Move_Right"):
		player.shimmy_cast.position.x += 10 * delta
	else:
		player.shimmy_cast.position.x = 0

	if Input.is_action_pressed("Move_Forward"):
		player.shimmy_cast.position.y += 10 * delta
	elif Input.is_action_pressed("Move_Back"):
		player.shimmy_cast.position.y -= 10 * delta
	else:
		player.shimmy_cast.position.y = 1.9
	
	player.shimmy_cast.position.x = clampf(player.shimmy_cast.position.x, -0.7, 0.7)
	player.shimmy_cast.position.y = clamp(player.shimmy_cast.position.y, 1.3, 3.0)
	
	
	normal = player.climb_normal_cast.get_collision_normal()
	player.TurnTo(-normal)
	player.SmoothLerp(targetPointA,delta)
	
func Exit(player: Player) -> void:
	player.climb_normal_cast.enabled = false
	player.climb_up_cast.enabled = false
