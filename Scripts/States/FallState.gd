class_name PlayerFallState
extends BasePlayerState


func Enter(player: Player) -> void:
	player.SetCrouch(false)
	player.animation_tree.set("parameters/movement/transition_request", "fall")
	
	player.obstacle_cast.enabled = true
	player.obstacle_cast.force_raycast_update()
	player.climb_normal_cast.enabled = true
	player.falling_die_cast.enabled = true

func PreUpdate(player: Player) -> void:
	if player.is_on_floor():
		player.ChangeStateTo(player.playerState.Land)
		
	if player.left_hand_climb_cast.is_colliding() or player.right_hand_climb_cast.is_colliding():
		#if player.climb_normal_cast.is_colliding():
			player.ChangeStateTo(player.playerState.HangingIdle)
	
	if player.velocity.y < -20 and not player.falling_die_cast.is_colliding():
		player.ChangeStateTo(player.playerState.Die)

func Update(player: Player, delta: float) -> void:
	var direction := player.GetMoveInput()
	player.velocity += player.get_gravity() * delta
	player.landSpeed = player.velocity.y
	player.UpdateVelocity(direction, delta, player.runSpeed * 0.5)
	player.TurnTo(direction)
	player.move_and_slide()
	
func Exit(player: Player) -> void:
	player.obstacle_cast.enabled = false
	player.falling_die_cast.enabled = false
	player.climb_normal_cast.enabled = false
