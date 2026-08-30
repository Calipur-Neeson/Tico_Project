class_name PlayerJumpState
extends BasePlayerState

var time: float

func Enter(player: Player) -> void:
	time = 0
	player.obstacle_cast.enabled = false
	player.animation_tree.set("parameters/movement/transition_request", "jump")

	
func PreUpdate(player: Player) -> void:
	if time > 0.5:
		player.jumpSpeed = player.velocity.length()
		player.velocity.y = player.jumpVelocity
		player.ChangeStateTo(PlayerState.Fall)
		

func Update(player: Player, delta: float) -> void:
	time += delta
	var direction := player.GetMoveInput()
	player.UpdateVelocity(direction, player.GetCurrentSpeed())
	player.move_and_slide()
	
