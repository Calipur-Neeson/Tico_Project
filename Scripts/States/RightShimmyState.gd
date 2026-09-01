class_name PlayerRightShimmyState
extends BasePlayerState

func Enter(player: Player) -> void:
	player.climb_normal_cast.enabled = true
	
func PreUpdate(player: Player) -> void:
	if not Input.is_action_pressed("Move_Right") or not player.shimmy_cast.is_colliding():
		player.ChangeStateTo(PlayerState.HangingIdle)


func Update(player: Player, delta: float) -> void:
	if Input.is_action_pressed("Move_Right"):
		player.shimmy_cast.position.x += 10 * delta
	
	if Input.is_action_pressed("Move_Forward"):
		player.shimmy_cast.position.y += 10 * delta
	elif Input.is_action_pressed("Move_Back"):
		player.shimmy_cast.position.y -= 10 * delta
	else:
		player.shimmy_cast.position.y = 1.9
	
	player.shimmy_cast.position.x = clampf(player.shimmy_cast.position.x, -0.7, 0.7)
	player.shimmy_cast.position.y = clamp(player.shimmy_cast.position.y, 1.3, 2.7)
	
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
