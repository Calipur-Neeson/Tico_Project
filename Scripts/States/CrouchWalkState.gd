class_name PlayerCrouchWalkState
extends BasePlayerState

	
func PreUpdate(player: Player) -> void:
	var currentSpeed = player.GetCurrentSpeed()
	if not player.is_on_floor():
		player.ChangeStateTo(PlayerState.Fall)

	elif currentSpeed <= 0.01:
		player.ChangeStateTo(PlayerState.CrouchIdle)


func Update(player: Player, delta: float) -> void:
	var direction := player.GetMoveInput()
	player.UpdateVelocity(direction, player.crouchSpeed)
	
	var walkSpeed: float = lerpf(0.1, 1.8, player.GetCurrentSpeed() / player.maxWalkSpeed)
	player.animation_tree.set("parameters/movement/transition_request", "crouchWalk")
	player.animation_tree.set("parameters/crouchSpeed/scale", walkSpeed)
	
	player.TurnTo(direction)
	player.move_and_slide()
