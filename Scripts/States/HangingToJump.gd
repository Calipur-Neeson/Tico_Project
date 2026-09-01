class_name PlayerHangingToJumpState
extends BasePlayerState

var normal :Vector3
var hitPoint: Vector3
var obstacleHight: float
var targetPointA: Vector3
var time: float

func Enter(player: Player) -> void:
	time = 0
	var back: Vector3 = player.global_basis.z
	targetPointA = player.shimmy_cast.get_collision_point() + back * 0.56
	targetPointA.y -= 1.9
	
	player.climb_normal_cast.enabled = true
	player.climb_normal_cast.force_raycast_update()
	player.climb_up_cast.enabled = true
	player.climb_up_cast.force_raycast_update()
	
	player.animation_tree.set("parameters/movement/transition_request", "hangJumpUp")
	
	
func PreUpdate(player: Player) -> void:
	if time > 0.6:
		player.ChangeStateTo(PlayerState.HangingIdle)
	

func Update(player: Player, delta: float) -> void:
	time += delta
	if Input.is_action_pressed("Move_Left"):
		player.shimmy_cast.position.x -= 10 * delta
	elif Input.is_action_pressed("Move_Right"):
		player.shimmy_cast.position.x += 10 * delta
	else:
		player.shimmy_cast.position.x = 0

	if Input.is_action_pressed("Move_Forward"):
		player.shimmy_cast.position.y += 10 * delta
	elif Input.is_action_pressed("Move_Back"):
		player.shimmy_cast.position.y -= 10 * delta
	else:
		player.shimmy_cast.position.y = 1.9
	
	player.shimmy_cast.position.x = clampf(player.shimmy_cast.position.x, -0.7, 0.7)
	player.shimmy_cast.position.y = clamp(player.shimmy_cast.position.y, 1.3, 3.0)
	
	
	normal = player.climb_normal_cast.get_collision_normal()
	player.TurnTo(-normal)
	player.SmoothLerp(targetPointA,delta * 4)
	
func Exit(player: Player) -> void:
	player.climb_normal_cast.enabled = false
	player.climb_up_cast.enabled = false
