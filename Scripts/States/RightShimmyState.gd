class_name PlayerRightShimmyState
extends BasePlayerState


func PreUpdate(player: Player) -> void:
	if not player.left_climb_cast.is_colliding() or not Input.is_action_pressed("Move_Right"):
		player.ChangeStateTo(PlayerState.HangingIdle)


func Update(player: Player, delta: float) -> void:
	var normal :Vector3 = player.climbable_cast.get_collision_normal()
	player.TurnTo(-normal)

	var hitPoint := player.right_climb_cast.get_collision_point()
	
	var direction := hitPoint - player.global_position
	direction.y = 0
	player.velocity = direction * 2.0
	player.move_and_slide()

	if player.floor_cast.is_colliding():
		player.playerAnim.play("NewLib/HangRightShimmy_short", player.BLEEND_SPEED)
	elif not player.floor_cast.is_colliding() :
		player.playerAnim.play("NewLib/HangRightShimmy", player.BLEEND_SPEED)
