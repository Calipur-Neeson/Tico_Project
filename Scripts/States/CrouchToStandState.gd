class_name PlayerCrouchToStandState
extends BasePlayerState

func Enter(player: Player) -> void:
	player.playerAnim.play("NewLib/CrouchToStand", player.BLEEND_SPEED)
	player.ceiling_cast.enabled = false

	
func PreUpdate(player: Player) -> void:
	if not player.playerAnim.is_playing():
		player.ChangeStateTo(PlayerState.Idle)
