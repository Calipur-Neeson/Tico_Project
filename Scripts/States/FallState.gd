class_name PlayerFallState
extends BasePlayerState

func Enter(player: Player) -> void:
	player.SetCrouch(false)
	player.animation_tree.set("parameters/movement/transition_request", "fall")

func PreUpdate(player: Player) -> void:
	if player.is_on_floor():
		player.ChangeStateTo(PlayerState.Land)
		
	elif player.climbable_cast.is_colliding() and not player.island:
		player.ChangeStateTo(PlayerState.HangingIdle)
	

func Update(player: Player, delta: float) -> void:
	var direction := player.GetMoveInput()
	player.velocity += player.get_gravity() * delta
	player.landSpeed = player.velocity.y
	player.UpdateVelocity(direction, player.runSpeed * 0.5)
	player.TurnTo(direction)
	player.move_and_slide()
	
	#player.left_ccdik_3d.influence = 0
	#player.right_ccdik_3d.influence = 0
