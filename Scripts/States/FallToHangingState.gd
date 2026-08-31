class_name PlayerFallToHangingState
extends BasePlayerState

var normal :Vector3
var hitPoint: Vector3
var obstacleHight: float
var targetPointA: Vector3
var time: float

func Enter(player: Player) -> void:
	player.climb_cast_vertical.enabled = true
	
	player.climb_cast_vertical.force_raycast_update()
	hitPoint = player.climb_cast_vertical.get_collision_point()
	
	obstacleHight = hitPoint.y - player.global_position.y
	
	targetPointA = player.global_position + Vector3(0, obstacleHight - 1.4, 0)

	player.climb_cast_horizontal.enabled = true
	normal = player.climb_cast_horizontal.get_collision_normal()
	#var right := player.global_basis.x.normalized()
	#player.left_arm_target.global_position = hitPoint - right * 0.3
	#player.right_arm_target.global_position = hitPoint + right * 0.3
	
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
	player.TurnTo(-normal)
	player.SmoothLerp(targetPointA,delta)
	#player.left_ccdik_3d.influence = move_toward(player.left_ccdik_3d.influence, 0.2, delta * 8.0)
	#player.right_ccdik_3d.influence = move_toward(player.right_ccdik_3d.influence, 0.2, delta * 8.0)
	
func Exit(player: Player) -> void:
	player.climb_cast_horizontal.enabled = false
	player.climb_cast_vertical.enabled = false
