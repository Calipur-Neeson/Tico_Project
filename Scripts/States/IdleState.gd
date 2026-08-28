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
			var hitPoint: Vector3 = player.obstacle_cast.get_collision_point()
			var playerFootPoint: Vector3 = player.global_position - Vector3(0, 1.75/2, 0)
			var obstacleHight: float = hitPoint.y - playerFootPoint.y
			
			player.assuming_land_cast.enabled = true
			player.assuming_land_cast.force_raycast_update()
			if obstacleHight < player.maxVaultHeight and not player.assuming_land_cast.is_colliding():
				player.ChangeStateTo(PlayerState.Vault)
			elif obstacleHight < player.maxVaultHeight and player.assuming_land_cast.is_colliding():
				player.ChangeStateTo(PlayerState.ClimbWall)
			elif obstacleHight >= player.maxVaultHeight:
				player.ChangeStateTo(PlayerState.HangingIdle)
		else:
			player.ChangeStateTo(PlayerState.Jump)
	
	elif Input.is_action_just_pressed("Crouch") and player.is_on_floor():
		player.ChangeStateTo(PlayerState.StandToCrouch)
	
	elif Input.is_action_pressed("Aim") and player.is_on_floor():
		player.ChangeStateTo(PlayerState.Aim)
	
