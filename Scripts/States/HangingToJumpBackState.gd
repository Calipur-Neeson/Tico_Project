class_name PlayerHangingToJumpBackState
extends BasePlayerState

var time: float
var normal :Vector3

func Enter(player: Player) -> void:
	time = 0
	player.animation_tree.set("parameters/movement/transition_request", "fall")
	
	normal = player.climb_normal_cast.get_collision_normal()

func PreUpdate(player: Player) -> void:
	if player.is_on_floor():
		player.ChangeStateTo(PlayerState.Land)
	
	if time > 0.3:
		player.ChangeStateTo(PlayerState.Fall)
		

func Update(player: Player, delta: float) -> void:
	time += delta
	player.TurnTo(normal)
	var direction := normal
	#player.velocity += player.get_gravity() * delta
	player.landSpeed = player.velocity.y
	player.UpdateVelocity(direction, player.runSpeed)
	player.TurnTo(direction)
	player.move_and_slide()
	
func Exit(player: Player) -> void:
	player.obstacle_cast.enabled = false
	
