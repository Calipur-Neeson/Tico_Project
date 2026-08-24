class_name PlayerStandToCrouchState
extends BasePlayerState

func Enter(player: Player) -> void:
	player.playerAnim.play("NewLib/StandToCrouch", player.BLEEND_SPEED)

	
func PreUpdate(player: Player) -> void:
	if not player.playerAnim.is_playing():
		player.ChangeStateTo(PlayerState.CrouchIdle)
