class_name PlayerWalkState
extends BasePlayerState


func PreUpdate(player: Player) -> void:
	var currentSpeed = player.GetCurrentSpeed()
	if not player.is_on_floor() and not player.floor_cast.is_colliding():
		player.ChangeStateTo(PlayerState.Fall)
		
	if currentSpeed > player.maxWalkSpeed:
		player.ChangeStateTo(PlayerState.Run)
	elif currentSpeed <= 0.01:
		player.ChangeStateTo(PlayerState.Idle)
		
	if Input.is_action_just_pressed("Jump") and player.is_on_floor():
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

func Update(player: Player, delta: float) -> void:
	var direction := player.GetMoveInput()
	player.TurnTo(direction)
	
	if player.wall_cast.is_colliding():
		player.velocity = Vector3.ZERO
		return
		
	player.velocity += player.get_gravity() * delta
	player.UpdateVelocity(direction)
	
	var walkSpeed: float = lerpf(0.1, 1.2, player.GetCurrentSpeed() / player.maxWalkSpeed)
	player.playerAnim.play("NewLib/Walking", player.BLEEND_SPEED, walkSpeed)
	
	player.move_and_slide()
