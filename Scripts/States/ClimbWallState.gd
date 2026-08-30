class_name PlayerClimbWallState
extends BasePlayerState

var hitPoint: Vector3

var obstacleHight: float
var targetPointA: Vector3

var time: float

func Enter(player: Player) -> void:
	time = 0
	player.assuming_land_cast.enabled = false
	player.collision_stand.disabled = true
	
	player.obstacle_cast.force_raycast_update()
	hitPoint = player.obstacle_cast.get_collision_point()
	player.obstacle_cast.enabled = false
	
	obstacleHight = hitPoint.y - player.global_position.y
	
	targetPointA = player.global_position + Vector3(0, obstacleHight - 1.57, 0)
	
	player.animation_tree.set("parameters/movement/transition_request", "climbUp")
	
func PreUpdate(player: Player) -> void:
	if time > 1.15:
		player.ChangeStateTo(PlayerState.Idle)

func Update(player: Player, delta: float) -> void:
	time += delta 
	if time < 0.15:
		player.SmoothLerp(targetPointA, delta * 10)
	if time > 1:
		player.collision_stand.disabled = false
	player.ApplyRootMotion(delta)
