class_name PlayerCrouchIdleState
extends BasePlayerState

func Enter(player: Player) -> void:
	player.SetCrouch(true)
	player.animation_tree.set("parameters/movement/transition_request", "crouchIdle")

func PreUpdate(player: Player) -> void:
	if not player.is_on_floor():
		player.ChangeStateTo(PlayerState.Fall)
		
	elif player.GetMoveInput().length() > 0.01:
		player.ChangeStateTo(PlayerState.CrouchWalk)
		
	elif Input.is_action_just_pressed("Jump") or Input.is_action_just_pressed("Crouch"):
		player.ceiling_cast.enabled = true
		player.ceiling_cast.force_shapecast_update()
		if not player.ceiling_cast.is_colliding():
			player.ChangeStateTo(PlayerState.Idle)
		else :
			player.ceiling_cast.enabled = false
	
	elif Input.is_action_pressed("Aim") and player.is_on_floor():
		player.ChangeStateTo(PlayerState.Aim)

func Exit(player: Player) -> void:
	player.ceiling_cast.enabled = false
