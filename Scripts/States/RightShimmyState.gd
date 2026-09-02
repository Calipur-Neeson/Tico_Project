class_name PlayerRightShimmyState
extends BasePlayerState

func Enter(player: Player) -> void:
	player.climb_normal_cast.enabled = true
	
func PreUpdate(player: Player) -> void:
	if not player.shimmy_cast.position.x > 0 or not player.right_climb_cast.is_colliding():
		player.ChangeStateTo(PlayerState.HangingIdle)


func Update(player: Player, delta: float) -> void:
	player.shimmy_cast.position.x += player.GetMoveInput().x * 10.0 * delta
	player.shimmy_cast.position.y -= player.GetMoveInput().z * 10.0 * delta
	
	if abs(player.GetMoveInput().x) <= 0.3:
		player.shimmy_cast.position.x = 0
	if player.GetMoveInput().z == 0:
		player.shimmy_cast.position.y = 1.9
	
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
