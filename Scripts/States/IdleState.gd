class_name PlayerIdleState
extends BasePlayerState

func Enter(player: Player) -> void:
	player.SetCrouch(false)
	player.animation_tree.set("parameters/movement/transition_request", "idle")
	
	player.left_climb_cast.enabled = false
	player.right_climb_cast.enabled = false


func PreUpdate(player: Player) -> void:
	if not player.is_on_floor() and not player.floor_cast.is_colliding():
		player.ChangeStateTo(player.playerState.Fall)
		
	elif player.GetMoveInput().length() > 0.01:
		player.ChangeStateTo(player.playerState.Walk)
		
	elif Input.is_action_just_pressed("Jump") and player.is_on_floor():
		player.obstacle_cast.enabled = true
		player.obstacle_cast.force_raycast_update()
		
		player.climb_up_cast.enabled = true
		player.climb_up_cast.force_raycast_update()
		
		if player.obstacle_cast.is_colliding():
			var hitPoint: Vector3 = player.obstacle_cast.get_collision_point()
			var obstacleHight: float = hitPoint.y - player.global_position.y
			
			if obstacleHight < player.maxVaultHeight and not player.assuming_land_cast.is_colliding():
				player.ChangeStateTo(player.playerState.Vault)
			elif obstacleHight < player.maxVaultHeight and not player.climb_up_cast.is_colliding():
				player.ChangeStateTo(player.playerState.ClimbWall)
			elif obstacleHight >= player.maxVaultHeight:
				player.ChangeStateTo(player.playerState.HangingIdle)
		else:
			player.ChangeStateTo(player.playerState.Jump)
	
	elif Input.is_action_just_pressed("Crouch") and player.is_on_floor():
		player.ChangeStateTo(player.playerState.CrouchIdle)
	
	elif Input.is_action_pressed("Aim") and player.is_on_floor():
		player.ChangeStateTo(player.playerState.Aim)
	
func Update(player: Player, delta: float) -> void:
	if player.is_on_floor():
		return
	player.velocity += player.get_gravity() * delta
	player.move_and_slide()
	
func Exit(player: Player) -> void:
	player.climb_up_cast.enabled = false
	player.obstacle_cast.enabled = false
