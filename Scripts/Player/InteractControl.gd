class_name InteractControl
extends ShapeCast3D

var currentObject: BaseInteractable
var isPicking: bool = false
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
		isPicking = true
	if isPicking:
		player.right_ik.influence = lerpf(player.right_ik.influence, 1, 0.1)
	
	
func GetInteractable() -> BaseInteractable:
	for i in range(get_collision_count()):
		var col := get_collider(i)
		if col is BaseInteractable:
			return col
		elif col.get_parent() is BaseInteractable:
			return col.get_parent()
	return null
	
