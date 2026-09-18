class_name BasePickable
extends BaseInteractable

@export var pickUpDelay: float = 0.2
@export var throwSpeed: float = 15.0

@onready var shape_cast_3d: ShapeCast3D = $ShapeCast3D
@onready var collision: CollisionShape3D = %CollisionShape3D
@onready var rigidBody: RigidBody3D = $"."


var isHeld: bool = false
var isThrown: bool = false
var gravity: float
var velocity: Vector3 


func _ready() -> void:
	super._ready()

func Interact(player: Player) -> void:
	if isInteracted:
		return
	
	super.Interact(player)
	PickUp(player)
	
func PickUp(player: Player) -> void:
	player.interactControl.Grab(self)
	

func Throw(direction: Vector3, player: Player) -> void:
	isHeld = false
	isThrown = true
	isInteracted = false
	
	reparent(get_tree().current_scene)
		
	velocity = direction.normalized() * throwSpeed
	rigidBody.freeze = false
	player.interactControl.objectInHand = null
	player.interactControl.hasItem = false


func _physics_process(delta: float) -> void:
	if not isThrown:
		return
	if shape_cast_3d.is_colliding():
		SoundEmitter.EmitSound(global_position, 8)
		queue_free()
		return

	position += velocity * delta
