class_name InteractControl
extends ShapeCast3D

var currentObject: BaseInteractable
var hasItem: bool = false
var objectInHand: BasePickable
@onready var panel: Panel = $"../../Panel"
@onready var interactText: RichTextLabel = $"../../Panel/RichTextLabel"
@onready var player: Player = $"../.."


func _ready() -> void:
	panel.hide()

func _physics_process(delta: float) -> void:
	if not is_colliding():
		panel.hide()
		if currentObject != null:
			currentObject.InteractExit()
		currentObject = null
		player.player_look_at.influence = 0
		return

	var newObject: BaseInteractable = GetInteractable()
	if currentObject == newObject:
		return

	if currentObject != null:
		currentObject.InteractExit()
	currentObject = newObject
	currentObject.InteractEnter()
	player.right_hand_point.global_position = currentObject.global_position
	player.player_look_at.influence = 1
	panel.show()
	interactText.text = currentObject.text
	

func _process(delta: float) -> void:
	if currentObject != null and Input.is_action_just_pressed("Interact"):
		currentObject.Interact(player)
		
	
func GetInteractable() -> BaseInteractable:
	for i in range(get_collision_count()):
		var col := get_collider(i)
		if col is BaseInteractable:
			return col
		elif col.get_parent() is BaseInteractable:
			return col.get_parent()
	return null
	
func Grab(item: BasePickable) -> void:
	Drop()
	
	var tween := create_tween()
	tween.tween_property(player.right_ik, "influence", 1.0, 0.2)
	if currentObject:
		if CaculateHeight() < 1:
			player.ChangeStateTo(player.playerState.CrouchIdle)
	await get_tree().create_timer(item.pickUpDelay).timeout

	item.reparent(player.right_hand_grab_pivot)
	item.position = Vector3.ZERO
	item.rigidBody.freeze = true
	item.collision.disabled = true
	hasItem = true
	objectInHand = item
	objectInHand.InteractExit()
	
	tween = create_tween()
	tween.tween_property(player.right_ik, "influence", 0.0, 0.15)
	player.ChangeStateTo(player.playerState.Idle)

func Drop() -> void:
	if hasItem and objectInHand:
		objectInHand.reparent(get_tree().current_scene)
		objectInHand.rigidBody.freeze = false
		objectInHand.collision.disabled = false
		objectInHand.isInteracted = false
		hasItem = false
		objectInHand = null
	
func CaculateHeight() -> float:
	return currentObject.global_position.y - player.global_position.y
