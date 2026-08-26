class_name PlayerLeftShimmyTurnState
extends BasePlayerState

var targetPoint: Vector3
var normal :Vector3

func Enter(player: Player) -> void:
	normal = player.left_turn_climb_cast.get_collision_normal()
	targetPoint = player.global_position
	targetPoint -= player.global_basis.x * 1.5
	targetPoint -= player.global_basis.z * 1

func PreUpdate(player: Player) -> void:
	pass


func Update(player: Player, delta: float) -> void:
	if player.global_position.x < targetPoint.x:
		player.velocity = Vector3.LEFT * 3
		player.move_and_slide()
	else :
		player.velocity = -player.global_basis.z * 1
		player.move_and_slide()
		
	player.TurnTo(normal)
	if player.floor_cast.is_colliding():
		player.playerAnim.play("NewLib/HangLeftShimmy_short", player.BLEEND_SPEED)
	elif not player.floor_cast.is_colliding() :
		player.playerAnim.play("NewLib/HangLeftShimmy", player.BLEEND_SPEED)
