class_name PlayerRunState
extends BasePlayerState

func Enter(player: Player) -> void:
	player.animation_tree.set("parameters/movement/transition_request", "run")

func PreUpdate(player: Player) -> void:
	var currentSpped = player.GetCurrentSpeed()
	if not player.is_on_floor() and not player.floor_cast.is_colliding():
		player.ChangeStateTo(PlayerState.Fall)
		
	if currentSpped <= player.maxWalkSpeed:
		player.ChangeStateTo(PlayerState.Walk)
		
	if Input.is_action_just_pressed("Jump") and player.is_on_floor():
		player.obstacle_cast.enabled = true
		player.obstacle_cast.force_raycast_update()
		
		player.climb_up_cast.enabled = true
		player.climb_up_cast.force_raycast_update()
		
		if player.obstacle_cast.is_colliding():
			var hitPoint: Vector3 = player.obstacle_cast.get_collision_point()
			var obstacleHight: float = hitPoint.y - player.global_position.y
			
			if obstacleHight < player.maxVaultHeight and not player.assuming_land_cast.is_colliding():
				player.ChangeStateTo(PlayerState.Vault)
			elif obstacleHight < player.maxVaultHeight and not player.climb_up_cast.is_colliding():
				player.ChangeStateTo(PlayerState.ClimbWall)
			elif obstacleHight >= player.maxVaultHeight:
				player.ChangeStateTo(PlayerState.HangingIdle)
		
		else:
			player.jumpSpeed = player.velocity.length()
			player.velocity.y = player.jumpVelocity
			player.ChangeStateTo(PlayerState.RunJump)
	
func Update(player: Player, delta: float) -> void:
	var direction := player.GetMoveInput()
	player.TurnTo(direction)
		
	player.velocity += player.get_gravity() * delta
	player.UpdateVelocity(direction)
	
	player.move_and_slide()
