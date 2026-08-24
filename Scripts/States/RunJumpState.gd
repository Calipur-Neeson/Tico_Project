class_name PlayerRunJumpState
extends BasePlayerState

func Enter(player: Player) -> void:
	player.playerAnim.play("NewLib/RunJump", player.BLEEND_SPEED)

func PreUpdate(player: Player) -> void:
	if player.is_on_floor():
		player.ChangeStateTo(PlayerState.Land)
	
	if player.climbable_cast.is_colliding():
		player.ChangeStateTo(PlayerState.HangingIdle)

func Update(player: Player, delta: float) -> void:
	player.velocity += player.get_gravity() * delta
	var direction := player.GetMoveInput()
	player.landSpeed = player.velocity.y
	player.UpdateVelocity(direction, player.jumpSpeed)
	player.TurnTo(direction)
	player.move_and_slide()
