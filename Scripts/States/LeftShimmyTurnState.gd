class_name PlayerLeftShimmyTurnState
extends BasePlayerState

var targetPoint: Vector3
var normal :Vector3
var targetA :Vector3
var targetB :Vector3
var time : float

func Enter(player: Player) -> void:
	time = 0
	player.climb_normal_cast.enabled = true
	player.animation_tree.set("parameters/movement/transition_request", "shimmyShortLeft")
	targetA = player.position - player.global_basis.x * 0.53
	targetB = targetA - player.global_basis.z * 0.76
	
	normal = player.left_turn_climb_cast.get_collision_normal()
	print(normal)

func PreUpdate(player: Player) -> void:
	if time > 0.8:
		player.ChangeStateTo(PlayerState.HangingIdle)


func Update(player: Player, delta: float) -> void:
	time += delta
	if time < 0.3:
		player.SmoothLerp(targetA, delta)
	else :
		player.SmoothLerp(targetB, delta)
		player.TurnTo(-normal)
	
