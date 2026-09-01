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
	
	player.animation_tree.set("parameters/movement/transition_request", "hangIdleShort")

	
	
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
	

func Update(player: Player, delta: float) -> void:
	normal = player.climb_normal_cast.get_collision_normal()
	player.TurnTo(-normal)
	player.SmoothLerp(targetPointA,delta)
	
func Exit(player: Player) -> void:
	player.climb_normal_cast.enabled = false
