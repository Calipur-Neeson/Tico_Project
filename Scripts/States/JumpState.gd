class_name PlayerJumpState
extends BasePlayerState

func Enter(player: Player) -> void:
	player.playerAnim.play("NewLib/ReadyToJump", player.BLEEND_SPEED, 3)

	
func PreUpdate(player: Player) -> void:
	if not player.playerAnim.is_playing():
		player.jumpSpeed = player.velocity.length()
		player.velocity.y = player.JUMP_VELOCITY
		player.ChangeStateTo(PlayerState.Fall)
		
	if player.climbable_cast.is_colliding():
		player.ChangeStateTo(PlayerState.HangingIdle)
		
		
func Update(player: Player, delta: float) -> void:
	var direction := player.GetMoveInput()
	player.UpdateVelocity(direction, player.GetCurrentSpeed())
	player.move_and_slide()
	
