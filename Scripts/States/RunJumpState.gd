class_name PlayerRunJumpState
extends BasePlayerState

func Enter(player: Player) -> void:
	player.obstacle_cast.enabled = false
	player.playerAnim.play("NewLib/RunJump", player.BLEEND_SPEED)

func PreUpdate(player: Player) -> void:
	player.obstacle_cast.enabled = true
	
	if player.is_on_floor():
		player.obstacle_cast.enabled = false
		player.ChangeStateTo(PlayerState.Land)
	
	if player.obstacle_cast.is_colliding() and not player.island:
		var hitPoint: Vector3 = player.obstacle_cast.get_collision_point()
		var height: float = hitPoint.y - player.global_position.y
		if 0.8 < height and height < 1.2: 
			player.ChangeStateTo(PlayerState.HangingIdle)

func Update(player: Player, delta: float) -> void:
	player.velocity += player.get_gravity() * delta
	var direction := player.GetMoveInput()
	player.landSpeed = player.velocity.y
	player.UpdateVelocity(direction, player.jumpSpeed)
	player.TurnTo(direction)
	player.move_and_slide()
