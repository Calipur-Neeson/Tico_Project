class_name PlayerClimbWallState
extends BasePlayerState

var targetPoint: Vector3

func Enter(player: Player) -> void:
	player.playerAnim.play("NewLib/ClimbWall", player.BLEEND_SPEED)
	targetPoint = player.global_position
	targetPoint += -player.global_basis.z * 0.5
	targetPoint.y += 2
	
func PreUpdate(player: Player) -> void:
	if not player.playerAnim.is_playing():
		player.ChangeStateTo(PlayerState.Idle)

func  Update(player: Player, delta: float) -> void:
	if player.global_position.y < targetPoint.y:
		player.velocity = Vector3.UP * 3
		player.move_and_slide()
	else :
		player.velocity = -player.global_basis.z * 1
		player.move_and_slide()
