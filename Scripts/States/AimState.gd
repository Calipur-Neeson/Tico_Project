class_name PlayerAimState
extends BasePlayerState

var isAim: bool = false
var direction: Vector3

func Enter(player: Player) -> void:
	isAim = true
	player.camControl.isReset = false
	
	direction = -player.cam.global_transform.basis.z.normalized()
	if player.container.currentItem:
		player.muzzle.isAim = true

func PreUpdate(player: Player) -> void:	
	if Input.is_action_just_released("Aim"):
		player.muzzle.isAim = false
		player.camControl.isReset = true
		if not player.isCrouch:
			player.ChangeStateTo(PlayerState.Idle)
		else :
			player.ChangeStateTo(PlayerState.CrouchIdle)
	
	if Input.is_action_just_released("Shot"):
		if player.container.currentItem != null:
			var item = player.container.currentItem.scene.instantiate()
			player.get_parent().add_child(item)
			item.global_position = player.muzzle.global_position

func Update(player: Player, delta: float) -> void:
	player.TurnTo(direction)
	if isAim:
		player.camControl.camRig.x = lerpf(player.camControl.camRig.x, 0.5, 10 * delta)
		player.spring_arm_3d.spring_length = lerpf(player.spring_arm_3d.spring_length, 0.5, 10 * delta)
	if player.isCrouch:
		player.camControl.camRig.y = lerpf(player.camControl.camRig.y, player.camControl.camHeightCrouch, 10 * delta)
	
