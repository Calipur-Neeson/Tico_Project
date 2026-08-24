class_name PlayerLandState
extends BasePlayerState

var landDirection: Vector3
var landVelociry: Vector3

func Enter(player: Player) -> void:
	if player.landSpeed < -11:
		if player.GetMoveInput():
			landDirection = player.GetMoveInput()
			landVelociry = player.velocity
			landVelociry.y = 0
			
			player.playerAnim.play("NewLib/LandRoll", player.BLEEND_SPEED, 1.5)
		else :
			player.playerAnim.play("NewLib/HardLanding", player.BLEEND_SPEED, 1.5)
	elif player.landSpeed < -8:
		player.playerAnim.play("NewLib/Landing", player.BLEEND_SPEED, 1.5)
	else:
		player.ChangeStateTo(PlayerState.Idle)

	player.jumpSpeed = 0

func PreUpdate(player: Player) -> void:
	if not player.playerAnim.is_playing():
		player.ChangeStateTo(PlayerState.Idle)

func Update(player: Player, delta: float) -> void:
	if player.playerAnim.current_animation == "NewLib/LandRoll":
		player.UpdateVelocity(landDirection, landVelociry.length())
	
		player.TurnTo(landDirection)
		player.move_and_slide()
