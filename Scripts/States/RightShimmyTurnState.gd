class_name PlayerRightShimmyTurnState
extends BasePlayerState

var targetPoint: Vector3
var normal :Vector3
var direction :Vector3
var dirRight : Vector3
var dirForward : Vector3

func Enter(player: Player) -> void:
	dirRight = player.global_basis.x
	dirForward = -player.global_basis.z
	
	normal = player.right_turn_climb_cast.get_collision_normal()
	targetPoint = player.right_turn_climb_cast.get_collision_point()
	direction = targetPoint - player.hand_pivot.global_position

func PreUpdate(player: Player) -> void:
	if player.climbable_cast.is_colliding() and player.right_climb_cast.is_colliding():
		player.ChangeStateTo(PlayerState.HangingIdle)


func Update(player: Player, delta: float) -> void:
	if player.climbable_cast.is_colliding():
		player.velocity = dirRight * 2.0
		player.move_and_slide()
	else:
		player.velocity = dirForward * 2.0
		player.move_and_slide()
		player.TurnTo(-normal)
	
	if player.floor_cast.is_colliding():
		player.playerAnim.play("NewLib/HangLeftShimmy_short", player.BLEEND_SPEED)
	elif not player.floor_cast.is_colliding() :
		player.playerAnim.play("NewLib/HangLeftShimmy", player.BLEEND_SPEED)
