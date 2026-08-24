class_name PlayerHangingIdleState
extends BasePlayerState

var normal :Vector3

func Enter(player: Player) -> void:
	#var hitPoint := player.climbable_cast.get_collision_point()
	normal = player.climbable_cast.get_collision_normal()
	
	if player.floor_cast.is_colliding():
		player.playerAnim.play("NewLib/HangingIdle_short", player.BLEEND_SPEED)
	else:	
		player.playerAnim.play("NewLib/HangingIdle", player.BLEEND_SPEED)
		

func PreUpdate(player: Player) -> void:
	if Input.is_action_just_pressed("Crouch"):
		player.ChangeStateTo(PlayerState.Fall)
	if player.left_climb_cast.is_colliding() and Input.is_action_pressed("Move_Left"):
		player.ChangeStateTo(PlayerState.LeftShimmy)
	elif player.right_climb_cast.is_colliding() and Input.is_action_pressed("Move_Right"):
		player.ChangeStateTo(PlayerState.RightShimmy)
	elif Input.is_action_pressed("Jump") and not player.ceiling_cast.is_colliding():
		player.ChangeStateTo(PlayerState.ClimbWall)

func Update(player: Player, delta: float) -> void:
	player.TurnTo(-normal)
	
