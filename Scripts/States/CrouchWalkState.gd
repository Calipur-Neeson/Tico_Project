class_name PlayerCrouchWalkState
extends BasePlayerState

func Enter(player: Player) -> void:
	player.SetCrouch(true)

func PreUpdate(player: Player) -> void:
	var currentSpeed = player.GetCurrentSpeed()
	if not player.is_on_floor():
		player.ChangeStateTo(player.playerState.Fall)

	elif currentSpeed <= 0.01:
		player.ChangeStateTo(player.playerState.CrouchIdle)
	
	if Input.is_action_just_pressed("Jump") or Input.is_action_just_pressed("Crouch"):
		player.ceiling_cast.enabled = true
		player.ceiling_cast.force_shapecast_update()
		if not player.ceiling_cast.is_colliding():
			player.ChangeStateTo(player.playerState.Walk)
		else :
			player.ceiling_cast.enabled = false


func Update(player: Player, delta: float) -> void:
	var direction := player.GetMoveInput()
	player.UpdateVelocity(direction, player.crouchSpeed)
	
	var walkSpeed: float = lerpf(0.1, 1.8, player.GetCurrentSpeed() / player.maxWalkSpeed)
	player.animation_tree.set("parameters/movement/transition_request", "crouchWalk")
	player.animation_tree.set("parameters/crouchSpeed/scale", walkSpeed)
	
	player.TurnTo(direction)
	player.move_and_slide()

func Exit(player: Player) -> void:
	player.ceiling_cast.enabled = false
