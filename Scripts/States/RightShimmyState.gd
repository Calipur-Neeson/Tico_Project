class_name PlayerRightShimmyState
extends BasePlayerState

var inversedInput: Vector3

func Enter(player: Player) -> void:
	player.climb_normal_cast.enabled = true
	
func PreUpdate(player: Player) -> void:
	if not player.shimmy_cast.position.x > 0 or not player.right_climb_cast.is_colliding():
		player.ChangeStateTo(PlayerState.HangingIdle)


func Update(player: Player, delta: float) -> void:
	inversedInput = player.global_transform.basis.inverse() * player.GetMoveInput()
	
	if abs(inversedInput.x) <= 0.4:
		player.shimmy_cast.position.x = 0
	else :
		player.shimmy_cast.position.x += inversedInput.x * 10.0 * delta
		
	if abs(inversedInput.z) <= 0.4:
		player.shimmy_cast.position.y = 1.9
	else:
		player.shimmy_cast.position.y -= inversedInput.z * 10.0 * delta	
	
	player.shimmy_cast.position.x = clampf(player.shimmy_cast.position.x, -player.shimmyDis, player.shimmyDis)
	player.shimmy_cast.position.y = clamp(player.shimmy_cast.position.y, 2 - player.shimmyJumpDis, 1.9 + player.shimmyJumpDis)
	
	var normal :Vector3 = player.climb_normal_cast.get_collision_normal()
	player.TurnTo(-normal)

	var hitPoint := player.right_climb_cast.get_collision_point()
	
	var direction := hitPoint - player.global_position
	direction.y = 0
	player.velocity = player.global_basis.x * 2.0
	player.move_and_slide()

	player.animation_tree.set("parameters/movement/transition_request", "shimmyShortRight")

func Exit(player: Player) -> void:
	player.velocity = Vector3.ZERO
	player.climb_normal_cast.enabled = false
