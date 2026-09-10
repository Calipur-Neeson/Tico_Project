class_name PlayerHangingToFallState
extends BasePlayerState

var time: float

func Enter(player: Player) -> void:
	player.animation_tree.set("parameters/movement/transition_request", "fall")
	
	player.shimmy_cast.enabled = true
	player.shimmy_cast.position.y -= 0.2
	player.climb_normal_cast.enabled = true


func PreUpdate(player: Player) -> void:
	if player.is_on_floor():
		player.ChangeStateTo(player.playerState.Land)
		
	if player.shimmy_cast.is_colliding() and not player.climb_normal_cast.is_colliding():
		player.ChangeStateTo(player.playerState.HangingIdle)
		

func Update(player: Player, delta: float) -> void:
	player.velocity += player.get_gravity() * delta
	player.landSpeed = player.velocity.y
	player.move_and_slide()
	
	
func Exit(player: Player) -> void:
	player.climb_normal_cast.enabled = false
