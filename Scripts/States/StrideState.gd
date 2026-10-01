class_name PlayerStrideState
extends BasePlayerState

var targetPoint: Vector3

func Enter(player: Player) -> void:
	player.animation_tree.set("parameters/movement/transition_request", "walk")
	player.animation_tree.set("parameters/walkSpeed/scale", 1)

func PreUpdate(player: Player) -> void:
	if player.global_position.distance_to(targetPoint) < 0.2:
		player.ChangeStateTo(player.playerState.Idle)

func Update(player: Player, delta: float) -> void:
	player.SmoothLerp(targetPoint, delta)

func Exit(player: Player) -> void:
	player.move_and_slide()
	
