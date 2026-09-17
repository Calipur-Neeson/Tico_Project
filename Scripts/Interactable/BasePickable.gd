class_name BasePickable
extends BaseInteractable

var time: float
var playerRef: Player
@onready var collision: CollisionShape3D = get_node("CollisionShape3D")

func _ready() -> void:
	super._ready()
	time = 0
	
func Interact(player: Player) -> void:
	playerRef = player
	super.Interact(player)
	
func _process(delta: float) -> void:
	if isInteracted:
		playerRef.right_ik.influence = lerpf(playerRef.right_ik.influence, 1, 0.1)
		time += delta
	if time >= 0.3:
		reparent(playerRef.right_hand_grab_pivot)
		position = Vector3.ZERO
		playerRef.right_ik.influence = 0
		collision.disabled = true
