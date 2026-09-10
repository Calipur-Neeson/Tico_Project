class_name PlayerRunJumpState
extends BasePlayerState

var time: float

func Enter(player: Player) -> void:
	time = 0
	player.obstacle_cast.enabled = false
	player.animation_tree.set("parameters/movement/transition_request", "runJump")

func PreUpdate(player: Player) -> void:
	player.obstacle_cast.enabled = true
	
	if not player.GetMoveInput() or time > 0.7:
		player.ChangeStateTo(player.playerState.Fall)
		
	if player.is_on_floor() and player.landSpeed > -7:
		player.obstacle_cast.enabled = false
		player.ChangeStateTo(player.playerState.Run)
	
	if player.obstacle_cast.is_colliding() and not player.island:
		var hitPoint: Vector3 = player.obstacle_cast.get_collision_point()
		var height: float = hitPoint.y - player.global_position.y
		if 1.4 < height and height < 1.6: 
			player.ChangeStateTo(player.playerState.HangingIdle)

func Update(player: Player, delta: float) -> void:
	time += delta
	player.velocity += player.get_gravity() * delta
	var direction := player.GetMoveInput()
	player.landSpeed = player.velocity.y
	player.UpdateVelocity(direction, player.jumpSpeed)
	player.TurnTo(direction)
	player.move_and_slide()
