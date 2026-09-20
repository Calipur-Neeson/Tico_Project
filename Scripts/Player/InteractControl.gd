class_name InteractControl
extends ShapeCast3D

var currentObject: BaseInteractable
var objectInHand: BasePickable

@onready var panel: Panel = $"../../Panel"
@onready var interactText: RichTextLabel = $"../../Panel/RichTextLabel"
@onready var player: Player = $"../.."


func _ready() -> void:
	panel.hide()

func _physics_process(delta: float) -> void:
	var newObject: BaseInteractable = GetInteractable()
	if currentObject == newObject:
		return
	SetCurrentObject(newObject)
	
func _process(delta: float) -> void:
	if currentObject != null and Input.is_action_just_pressed("Interact"):
		currentObject.Interact(player)
		
func SetCurrentObject(newObject: BaseInteractable) -> void:
	if currentObject:
		currentObject.InteractExit()

	currentObject = newObject

	if currentObject == null:
		panel.hide()
		player.player_look_at.influence = 0
		return

	currentObject.InteractEnter()

	player.right_hand_point.global_position = currentObject.global_position
	player.player_look_at.influence = 1

	interactText.text = currentObject.text
	panel.show()
	
	
func GetInteractable() -> BaseInteractable:
	for i in range(get_collision_count()):
		var collider := get_collider(i)
		if collider is BaseInteractable:
			return collider
		elif collider.get_parent() is BaseInteractable:
			return collider.get_parent()
	return null
	
func Grab(item: BasePickable) -> void:
	Drop()
	player.playerState.Pickup.itemPickup = item
	if player.state == player.playerState.Idle:
		player.playerState.Pickup.originalPose = PlayerPickupState.PickupPose.STANDING
	elif player.state == player.playerState.CrouchIdle:
		player.playerState.Pickup.originalPose = PlayerPickupState.PickupPose.CROUCHING
	player.ChangeStateTo(player.playerState.Pickup)
	

func Drop() -> void:
	if not objectInHand:
		return
		
	objectInHand.Drop()
	objectInHand = null
	
func ClearHeldItem() -> void:
	objectInHand = null

func CaculateHeight() -> float:
	return currentObject.global_position.y - player.global_position.y
