class_name Player
extends CharacterBody3D

@export var runSpeed:float = 5.0
@export var crouchSpeed:float = 2.0
@export var JUMP_VELOCITY:float = 6

@onready var spring_arm_3d: CameraControl = $SpringArm3D
@onready var cam: Camera3D = $SpringArm3D/Camera3D
@onready var playerAnim: AnimationPlayer = $Mesh/AnimationPlayer
@onready var container: PlayerContainer = $Container
@onready var muzzle: Trajectory = $Muzzle

#Colliders
@onready var collision_stand: CollisionShape3D = $CollisionStand
@onready var collision_crouch: CollisionShape3D = $CollisionCrouch

#Caster
@onready var climbable_cast: RayCast3D = $RayDetectors/ClimbCast
@onready var floor_cast: ShapeCast3D = $RayDetectors/FloorCast
@onready var left_climb_cast: RayCast3D = $RayDetectors/LeftClimbCast
@onready var right_climb_cast: RayCast3D = $RayDetectors/RightClimbCast
@onready var ceiling_cast: ShapeCast3D = $RayDetectors/CeilingCast
@onready var wall_cast: RayCast3D = $RayDetectors/WallCast
@onready var right_turn_climb_cast: RayCast3D = $RayDetectors/RightTurnClimbCast
@onready var left_turn_climb_cast: RayCast3D = $RayDetectors/LeftTurnClimbCast
@onready var obstacle_cast: RayCast3D = $RayDetectors/ObstacleCast


#Hand Pivot
@onready var hand_pivot: Marker3D = $HandPivot


var camControl: CameraControl
var jumpSpeed: float
var landSpeed: float
var maxWalkSpeed: float = 3
const BLEEND_SPEED: float = 0.2
var isCrouch: bool = false
var island: bool = false

#Current state that our player is
var state: BasePlayerState = PlayerState.Idle

func _ready() -> void:
	ceiling_cast.enabled = false
	obstacle_cast.enabled = false
	
	state.Enter(self)
	camControl = spring_arm_3d

func ChangeStateTo(nextState: BasePlayerState) -> void:
	state.Exit(self)
	state = nextState
	state.Enter(self)

func _physics_process(delta: float) -> void:
	state.PreUpdate(self)
	state.Update(self, delta)

func TurnTo(direction: Vector3) -> void:
	if direction:
		var yaw: = atan2(-direction.x, -direction.z)
		yaw = lerp_angle(rotation.y, yaw, 0.25)
		rotation.y = yaw

func GetMoveInput() -> Vector3:
	var input_dir := Input.get_vector("Move_Left", "Move_Right", "Move_Forward", "Move_Back")
	var direction := (cam.global_basis * Vector3(input_dir.x, 0, input_dir.y))
	direction = Vector3(direction.x, 0, direction.z).normalized() * input_dir.length()
	return direction
	
func GetCurrentSpeed() -> float:
	return velocity.length()
	
func UpdateVelocity(direction: Vector3, speed: float = runSpeed) -> void:
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, 1)
		velocity.z = move_toward(velocity.z, 0, 1)

func SetCrouch(crouch: bool) -> void:
	isCrouch = crouch
	collision_crouch.disabled = !crouch
	collision_stand.disabled = crouch

func ForceMovePlayer(offset: Vector3) -> void:
	var tween = create_tween()
	tween.tween_property(self, "position", position + offset, 0.1)
	
