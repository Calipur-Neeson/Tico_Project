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
		player.ChangeStateTo(PlayerState.Jump)

func Update(player: Player, delta: float) -> void:
	var direction := player.GetMoveInput()
	player.velocity += player.get_gravity() * delta
	player.UpdateVelocity(direction)
	
	var walkSpeed: float = lerpf(0.1, 1.2, player.GetCurrentSpeed() / player.maxWalkSpeed)
	player.playerAnim.play("NewLib/Walking", player.BLEEND_SPEED, walkSpeed)
	
	player.TurnTo(direction)
	player.move_and_slide()
