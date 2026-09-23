class_name PlayerRunJumpState
extends BasePlayerState

var time: float

func Enter(player: Player) -> void:
	time = 0
	player.obstacle_cast.enabled = false
	player.climb_normal_cast.enabled = true
	player.animation_tree.set("parameters/movement/transition_request", "runJump")

func PreUpdate(player: Player) -> void:
	if not player.GetMoveInput() or time > 0.7:
		player.ChangeStateTo(player.playerState.Fall)
		
	if player.is_on_floor() and player.landSpeed > -7:
		player.obstacle_cast.enabled = false
		player.ChangeStateTo(player.playerState.Run)
	
	if player.left_hand_climb_cast.is_colliding() or player.right_hand_climb_cast.is_colliding():
		if player.climb_normal_cast.is_colliding():
			player.ChangeStateTo(player.playerState.HangingIdle)

func Update(player: Player, delta: float) -> void:
	time += delta
	player.velocity += player.get_gravity() * delta
	var direction := player.GetMoveInput()
	player.landSpeed = player.velocity.y
	player.UpdateVelocity(direction, player.jumpSpeed)
	player.TurnTo(direction)
	player.move_and_slide()

func Exit(player: Player) -> void:
	player.climb_normal_cast.enabled = false
