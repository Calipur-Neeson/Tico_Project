class_name PlayerPickupState
extends BasePlayerState

enum PickupPose {
	STANDING,
	CROUCHING
}

var originalPose: PickupPose
var itemPickup: BasePickable
var time: float
var height: float
var blend: float
var hasPicked: bool

func Enter(player: Player) -> void:
	hasPicked = false
	time = 0
	height = player.interactControl.CaculateHeight()
	
	var tween := player.create_tween()
	tween.tween_property(player.right_ik, "influence", 1.0, 0.2)
	
	if height < 0.8 and originalPose == PickupPose.STANDING:
		blend = 1 - height / 0.8
		player.animation_tree.set("parameters/movement/transition_request", "crouchToPick")
		player.animation_tree.set("parameters/crouchBlend/blend_amount", blend)
	elif height > 1.0 and originalPose == PickupPose.CROUCHING:
		blend = height - 1
		blend = clampf(blend, 0, 1)
		player.animation_tree.set("parameters/movement/transition_request", "idle")
		player.animation_tree.set("parameters/standBlend/blend_amount", blend)

func PreUpdate(player: Player) -> void:
	if time >= 2 * itemPickup.pickUpDelay:
		if originalPose == PickupPose.STANDING:
			player.ChangeStateTo(player.playerState.Idle)
		elif originalPose == PickupPose.CROUCHING:
			player.ChangeStateTo(player.playerState.CrouchIdle)
	elif time >= itemPickup.pickUpDelay:
		player.right_ik.influence = lerpf(player.right_ik.influence, 0, 0.15)
		if not hasPicked:
			hasPicked = true
			itemPickup.SetHeld(player)
			player.interactControl.objectInHand = itemPickup
			itemPickup.InteractExit()
		
			if originalPose == PickupPose.STANDING:
				player.animation_tree.set("parameters/movement/transition_request", "idle")
			elif originalPose == PickupPose.CROUCHING:
				player.animation_tree.set("parameters/movement/transition_request", "crouchIdle")

func Update(player: Player, delta: float) -> void:
	time += delta
