class_name PlayerRunState
extends BasePlayerState

func Enter(player: Player) -> void:
	player.playerAnim.play("NewLib/Running", player.BLEEND_SPEED)

func PreUpdate(player: Player) -> void:
	var currentSpped = player.GetCurrentSpeed()
	if not player.is_on_floor() and not player.floor_cast.is_colliding():
		player.ChangeStateTo(PlayerState.Fall)
		
	if currentSpped <= player.maxWalkSpeed:
		player.ChangeStateTo(PlayerState.Walk)
		
	if Input.is_action_just_pressed("Jump") and player.is_on_floor():
		player.obstacle_cast.enabled = true
		player.obstacle_cast.force_raycast_update()
		
		if player.obstacle_cast.is_colliding():
			player.ChangeStateTo(PlayerState.Vault)
		else:
			player.jumpSpeed = player.velocity.length()
			player.velocity.y = player.JUMP_VELOCITY
			player.ChangeStateTo(PlayerState.RunJump)
	
func Update(player: Player, delta: float) -> void:
	var direction := player.GetMoveInput()
	player.TurnTo(direction)
	
	if player.wall_cast.is_colliding():
		player.velocity = Vector3.ZERO
		return
		
	player.velocity += player.get_gravity() * delta
	player.UpdateVelocity(direction)
	
	player.move_and_slide()
