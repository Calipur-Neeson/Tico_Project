class_name PlayerVaultState
extends BasePlayerState

var hitPoint: Vector3
var playerFootPoint: Vector3
var obstacleHight: float
var targetPointA: Vector3

var time: float


func Enter(player: Player) -> void:
	time = 0
	player.collision_stand.disabled = true
	player.assuming_land_cast.enabled = false
	
	player.obstacle_cast.force_raycast_update()
	hitPoint = player.obstacle_cast.get_collision_point()
	player.obstacle_cast.enabled = false
	
	playerFootPoint = player.global_position - Vector3(0, 1.75/2, 0)
	obstacleHight = hitPoint.y - playerFootPoint.y
	targetPointA = player.global_position + Vector3(0, obstacleHight - 0.5, 0) + (-player.global_basis.z * 0.18)
	
	player.animation_tree.set("parameters/movement/transition_request", "vault")

func PreUpdate(player: Player) -> void:
	if time >= 1.7:
		player.ChangeStateTo(PlayerState.Idle)

func Update(player: Player, delta: float) -> void:
	time += delta
	player.ApplyRootMotion(delta)
	
