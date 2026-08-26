class_name PlayerHangingIdleState
extends BasePlayerState

var normal :Vector3
var hitPoint: Vector3

func Enter(player: Player) -> void:
	hitPoint = player.climbable_cast.get_collision_point()
	normal = player.climbable_cast.get_collision_normal()
	
	if player.floor_cast.is_colliding():
		player.playerAnim.play("NewLib/HangingIdle_short", player.BLEEND_SPEED)
	else:	
		player.playerAnim.play("NewLib/HangingIdle", player.BLEEND_SPEED)
	
	var move: Vector3 = hitPoint - player.hand_pivot.global_position
	player.ForceMovePlayer(move)

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
	
