class_name PlayerIdleState
extends BasePlayerState

func Enter(player: Player) -> void:
	player.SetCrouch(false)
	player.playerAnim.play("NewLib/Idle", player.BLEEND_SPEED)

func PreUpdate(player: Player) -> void:
	if not player.is_on_floor():
		player.ChangeStateTo(PlayerState.Fall)
		
	elif player.GetMoveInput().length() > 0.01:
		player.ChangeStateTo(PlayerState.Walk)
		
	elif Input.is_action_just_pressed("Jump") and player.is_on_floor():
		player.obstacle_cast.enabled = true
		player.obstacle_cast.force_raycast_update()
		
		if player.obstacle_cast.is_colliding():
			player.ChangeStateTo(PlayerState.Vault)
		else:
			player.ChangeStateTo(PlayerState.Jump)
	
	elif Input.is_action_just_pressed("Crouch") and player.is_on_floor():
		player.ChangeStateTo(PlayerState.StandToCrouch)
	
	elif Input.is_action_pressed("Aim") and player.is_on_floor():
		player.ChangeStateTo(PlayerState.Aim)
	
