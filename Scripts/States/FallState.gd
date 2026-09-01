class_name PlayerFallState
extends BasePlayerState

var detected_object: Node3D

func Enter(player: Player) -> void:
	player.SetCrouch(false)
	#player.climb_cast_horizontal.enabled = true
	player.animation_tree.set("parameters/movement/transition_request", "fall")
	#if player.climb_cast_horizontal.is_colliding():
		#detected_object = player.climb_cast_horizontal.get_collider()
	player.obstacle_cast.enabled = true
	player.obstacle_cast.force_raycast_update()

func PreUpdate(player: Player) -> void:
	if player.is_on_floor():
		player.ChangeStateTo(PlayerState.Land)
		
	if player.obstacle_cast.is_colliding():
		var hitPoint: Vector3 = player.obstacle_cast.get_collision_point()
		var obstacleHight: float = hitPoint.y - player.global_position.y
			
		if obstacleHight >= player.maxVaultHeight:
			player.ChangeStateTo(PlayerState.HangingIdle)
		

func Update(player: Player, delta: float) -> void:
	var direction := player.GetMoveInput()
	player.velocity += player.get_gravity() * delta
	player.landSpeed = player.velocity.y
	player.UpdateVelocity(direction, player.runSpeed * 0.5)
	player.TurnTo(direction)
	player.move_and_slide()
	
func Exit(player: Player) -> void:
	player.obstacle_cast.enabled = false
	detected_object = null
