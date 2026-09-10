class_name PlayerFallState
extends BasePlayerState


func Enter(player: Player) -> void:
	player.SetCrouch(false)
	player.animation_tree.set("parameters/movement/transition_request", "fall")
	
	player.obstacle_cast.enabled = true
	player.obstacle_cast.force_raycast_update()

func PreUpdate(player: Player) -> void:
	if player.is_on_floor():
		player.ChangeStateTo(player.playerState.Land)
		
	if player.obstacle_cast.is_colliding():
		var hitPoint: Vector3 = player.obstacle_cast.get_collision_point()
		var obstacleHight: float = hitPoint.y - player.global_position.y
			
		if obstacleHight >= player.maxVaultHeight:
			player.ChangeStateTo(player.playerState.HangingIdle)
		

func Update(player: Player, delta: float) -> void:
	var direction := player.GetMoveInput()
	player.velocity += player.get_gravity() * delta
	player.landSpeed = player.velocity.y
	player.UpdateVelocity(direction, player.runSpeed * 0.5)
	player.TurnTo(direction)
	player.move_and_slide()
	
func Exit(player: Player) -> void:
	player.obstacle_cast.enabled = false
