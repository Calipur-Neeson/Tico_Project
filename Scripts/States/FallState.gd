class_name PlayerFallState
extends BasePlayerState

var detected_object: Node3D

func Enter(player: Player) -> void:
	player.SetCrouch(false)
	player.climb_cast_horizontal.enabled = true
	player.animation_tree.set("parameters/movement/transition_request", "fall")
	if player.climb_cast_horizontal.is_colliding():
		detected_object = player.climb_cast_horizontal.get_collider()

func PreUpdate(player: Player) -> void:
	if player.is_on_floor():
		player.ChangeStateTo(PlayerState.Land)
		
	if player.climb_cast_horizontal.is_colliding():
		print("hit", player.climb_cast_horizontal.is_colliding())
		print(detected_object)
		if player.climb_cast_horizontal.get_collider() != detected_object or detected_object == null:
			player.ChangeStateTo(PlayerState.FallToHanging)
		

func Update(player: Player, delta: float) -> void:
	var direction := player.GetMoveInput()
	player.velocity += player.get_gravity() * delta
	player.landSpeed = player.velocity.y
	player.UpdateVelocity(direction, player.runSpeed * 0.5)
	player.TurnTo(direction)
	player.move_and_slide()
	
func Exit(player: Player) -> void:
	player.climb_cast_horizontal.enabled = false
	detected_object = null
