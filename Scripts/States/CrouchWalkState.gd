class_name PlayerCrouchWalkState
extends BasePlayerState

	
func PreUpdate(player: Player) -> void:
	var currentSpeed = player.GetCurrentSpeed()
	if not player.is_on_floor():
		player.ChangeStateTo(PlayerState.Fall)

	elif currentSpeed <= 0.01:
		player.ChangeStateTo(PlayerState.CrouchIdle)


func Update(player: Player, delta: float) -> void:
	var direction := player.GetMoveInput()
	player.UpdateVelocity(direction, player.crouchSpeed)
	
	var walkSpeed: float = lerpf(0.1, 1.2, player.GetCurrentSpeed() / player.maxWalkSpeed)
	player.playerAnim.play("NewLib/CrouchWalking", player.BLEEND_SPEED, walkSpeed)
	
	player.TurnTo(direction)
	player.move_and_slide()
