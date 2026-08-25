class_name PlayerCrouchIdleState
extends BasePlayerState

func Enter(player: Player) -> void:
	player.isCrouch = true
	player.playerAnim.play("NewLib/CrouchIdle", player.BLEEND_SPEED)

func PreUpdate(player: Player) -> void:
	if not player.is_on_floor():
		player.ChangeStateTo(PlayerState.Fall)
		
	elif player.GetMoveInput().length() > 0.01:
		player.ChangeStateTo(PlayerState.CrouchWalk)
		
	elif Input.is_action_just_pressed("Jump") or Input.is_action_just_pressed("Crouch"):
		player.ChangeStateTo(PlayerState.CrouchToStand)
	
	elif Input.is_action_pressed("Aim") and player.is_on_floor():
		player.ChangeStateTo(PlayerState.Aim)
