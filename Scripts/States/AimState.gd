class_name PlayerAimState
extends BasePlayerState

var isAim: bool = false
var direction: Vector3

func Enter(player: Player) -> void:
	isAim = true
	player.camControl.isReset = false
	
	if player.interactControl.hasItem:
		player.muzzle.isAim = true

func PreUpdate(player: Player) -> void:	
	if Input.is_action_just_released("Aim"):
		player.muzzle.isAim = false
		player.camControl.isReset = true
		if not player.isCrouch:
			player.ChangeStateTo(player.playerState.Idle)
		else :
			player.ChangeStateTo(player.playerState.CrouchIdle)
	
	direction = -player.cam.global_transform.basis.z.normalized()
	if Input.is_action_just_released("Shot"):
		if player.interactControl.objectInHand and player.interactControl.objectInHand is BasePickable:
			player.interactControl.objectInHand.global_position = player.muzzle.global_position
			player.interactControl.objectInHand.Throw(direction, player)

func Update(player: Player, delta: float) -> void:
	player.TurnTo(direction)
	if isAim:
		player.camControl.camRig.x = lerpf(player.camControl.camRig.x, 0.5, 10 * delta)
		player.spring_arm_3d.spring_length = lerpf(player.spring_arm_3d.spring_length, 0.5, 10 * delta)
	if player.isCrouch:
		player.camControl.camRig.y = lerpf(player.camControl.camRig.y, player.camControl.camHeightCrouch, 10 * delta)
	
