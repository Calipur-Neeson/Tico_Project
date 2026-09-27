class_name Player
extends CharacterBody3D

@export var runSpeed:float = 5.0
@export var crouchSpeed:float = 2.0
@export var jumpVelocity:float = 6
@export var maxVaultHeight: float = 1.3
@export var shimmyDis: float = 1.0
@export var shimmyJumpDis: float = 1.1
@export var acceleration: float = 10
@export var deceleration: float = 20

# Foot IK
@export_group("Foot IK")
@export var visual_for_IK: Node3D
@export var ik_leg_left: TwoBoneIK3D
@export var ik_leg_right: TwoBoneIK3D
@export var ray_leg_left_front: RayCast3D
@export var ray_leg_left_back: RayCast3D
@export var ray_leg_right_front: RayCast3D
@export var ray_leg_right_back: RayCast3D
@export var target_leg_left: Marker3D
@export var target_leg_right: Marker3D
@export var ik_is_enabled: bool = false
@export_range(0.0, 1.0, 0.05) var front_ray_weight: float = 0.5
@export_range(-1, 1, 0.01) var pos_y_height_up: float = 0.11  
@export_range(-1, 1, 0.01) var pos_y_height_flat: float = 0.11  
@export_range(-1, 1, 0.01) var pos_y_height_down: float = 0.1  
@export_range(-1, 1, 0.01) var slope_threshold: float = -0.02
@export_range(0, 100, 1.0) var ik_lerp_speed: float = 10.0
@export_range(0, 1, 0.01) var active_ik_influence: float = 1.0
var inactive_ik_influence: float = 0.0
var last_offset_l: float = 0.0
var last_offset_r: float = 0.0

@onready var spring_arm_3d: CameraControl = $SpringArm3D
@onready var cam: Camera3D = $SpringArm3D/Camera3D
@onready var container: PlayerContainer = $Container
@onready var muzzle: Trajectory = $Muzzle
@onready var playerState: PlayerState = $StateMachine
@onready var heatSystem: HeatSystem = $HeatMeter
@onready var interactControl: InteractControl = $RayDetectors/InteractCast


#Animator
@onready var animation_player: AnimationPlayer = $Character/AnimationPlayer
@onready var animation_tree: AnimationTree = $Character/AnimationTree
@onready var right_ik: CCDIK3D = $"Character/Y Bot/Skeleton3D/RightIK"
@onready var left_ik: CCDIK3D = $"Character/Y Bot/Skeleton3D/LeftIK"
@onready var left_hand_point: Node3D = $LeftHandPoint
@onready var right_hand_point: Node3D = $RightHandPoint
@onready var physical_bone_simulator_3d: PhysicalBoneSimulator3D = $"Character/Y Bot/Skeleton3D/PhysicalBoneSimulator3D"
@onready var player_look_at: LookAtModifier3D = $"Character/Y Bot/Skeleton3D/PlayerLookAt"
@onready var right_hand_grab_pivot: Marker3D = $"Character/Y Bot/Skeleton3D/RightHandGrab/HandPivot"



#Colliders
@onready var collision_stand: CollisionShape3D = $CollisionStand
@onready var collision_crouch: CollisionShape3D = $CollisionCrouch
@onready var collision_upper: CollisionShape3D = $CollisionUpper


#Caster
@onready var climb_normal_cast: RayCast3D = $RayDetectors/ClimbNormalCast
@onready var climb_up_cast: RayCast3D = $RayDetectors/ClimbUpCast
@onready var shimmy_cast: RayCast3D = $RayDetectors/ShimmyCast
#@onready var floor_cast: ShapeCast3D = $RayDetectors/FloorCast
@onready var left_climb_cast: RayCast3D = $RayDetectors/LeftClimbCast
@onready var right_climb_cast: RayCast3D = $RayDetectors/RightClimbCast
@onready var ceiling_cast: ShapeCast3D = $RayDetectors/CeilingCast
#@onready var wall_cast: ShapeCast3D = $RayDetectors/WallCast
@onready var right_turn_climb_cast: RayCast3D = $RayDetectors/RightTurnClimbCast
@onready var left_turn_climb_cast: RayCast3D = $RayDetectors/LeftTurnClimbCast
@onready var obstacle_cast: RayCast3D = $RayDetectors/ObstacleCast
@onready var assuming_land_cast: RayCast3D = $RayDetectors/AssumingLandCast
@onready var left_hand_climb_cast: RayCast3D = $RayDetectors/LeftHandClimbCast
@onready var right_hand_climb_cast: RayCast3D = $RayDetectors/RightHandClimbCast
@onready var falling_die_cast: RayCast3D = $RayDetectors/FallingDieCast


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
var state: BasePlayerState 

func _ready() -> void:
	ceiling_cast.enabled = false
	obstacle_cast.enabled = false
	assuming_land_cast.enabled = false
	climb_normal_cast.enabled = false
	falling_die_cast.enabled = false
	
	state = playerState.Idle
	state.Enter(self)
	camControl = spring_arm_3d
	
	GameManager.OnGameRestart.connect(ReSetPositon)
	#if GameManager.currentGameState == GameManager.GameState.RESTART:
		#GameManager.OnGameRestart.emit()
	GameManager.OnGameStateChanged.connect(OnGameStateChanged)
	

func ChangeStateTo(nextState: BasePlayerState) -> void:
	state.Exit(self)
	state = nextState
	state.Enter(self)

func _physics_process(delta: float) -> void:
	state.PreUpdate(self)
	state.Update(self, delta)
	
	handle_leg_ik(delta)

func OnGameStateChanged(state: GameManager.GameState) -> void:
	if state == GameManager.GameState.RESTART:
		ReSetPositon()
		GameManager.SetGameState(GameManager.GameState.PLAYING)
		GameManager.OnGameStateChanged.emit(GameManager.currentGameState)
	if state == GameManager.GameState.PLAYING:
		set_process(true)
		set_physics_process(true)
	else:
		set_process(false)
		set_physics_process(false)


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
	
func UpdateVelocity(direction: Vector3, delta: float, speed: float = runSpeed) -> void:
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		#var targetVelocity := direction * speed
		#if abs(velocity.dot(targetVelocity)) < 0:
			#velocity.x = move_toward(velocity.x, targetVelocity.x, acceleration * 10 * delta)
			#velocity.z = move_toward(velocity.z, targetVelocity.z, acceleration * 10 * delta)
		#else:
			#velocity.x = move_toward(velocity.x, targetVelocity.x, acceleration * delta)
			#velocity.z = move_toward(velocity.z, targetVelocity.z, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, 1)
		velocity.z = move_toward(velocity.z, 0, 1)
		#velocity.x = move_toward(velocity.x, 0, deceleration * delta)
		#velocity.z = move_toward(velocity.z, 0, deceleration * delta)

func SetCrouch(crouch: bool) -> void:
	isCrouch = crouch
	collision_crouch.disabled = !crouch
	collision_stand.disabled = crouch
	collision_upper.disabled = true

func SmoothLerp(to: Vector3, delta: float) -> void:
	var speed: = delta *2
	var distance: float = position.distance_to(to)
	var timer = clamp(speed / distance, 0, 1)
	position = position.lerp(to, timer)
	
func ApplyRootMotion(delta: float) -> void:
	var root_motion: Vector3 = animation_tree.get_root_motion_position() 
	root_motion.z *= -1
	root_motion.x *= -1
	
	var movement := global_basis * root_motion
	velocity = movement / delta
	
	move_and_slide()

func ReSetPositon() -> void:
	if not QuickSave.load_var("PlayerPosition"):
		print("NO Data")
		return
	var pos: Vector3 = QuickSave.load_var("PlayerPosition")
	self.position = pos

func handle_leg_ik(delta: float) -> void:
	#var should_ik_be_active: bool = is_on_floor() and (ik_is_enabled or !can_player_move)
	var should_ik_be_active: bool = state is PlayerIdleState

	ik_leg_left.active = should_ik_be_active
	ik_leg_right.active = should_ik_be_active

	if should_ik_be_active:
		last_offset_l = _process_leg_ik(ray_leg_left_front, ray_leg_left_back, target_leg_left, ik_leg_left, delta)
		last_offset_r = _process_leg_ik(ray_leg_right_front, ray_leg_right_back, target_leg_right, ik_leg_right, delta)

		choose_lowest_gap(delta)

	else:
		visual_for_IK.position.y = lerp(visual_for_IK.position.y, 0.0, 15.0 * delta)
		ik_leg_left.influence = 0.0
		ik_leg_right.influence = 0.0


func choose_lowest_gap(delta: float) -> void:
	var lowest_gap: float = min(last_offset_l, last_offset_r)

	if lowest_gap < 0.0:
		visual_for_IK.position.y = lerp(visual_for_IK.position.y, lowest_gap, 10.0 * delta)
	else:
		visual_for_IK.position.y = lerp(visual_for_IK.position.y, 0.0, 10.0 * delta)


func _process_leg_ik(ray_f: RayCast3D, ray_b: RayCast3D, target_marker: Marker3D, ik: TwoBoneIK3D, delta: float) -> float:
	var is_f_colliding: bool = ray_f.is_colliding()
	var is_b_colliding: bool = ray_b.is_colliding()

	if not (is_f_colliding or is_b_colliding):
		ik.influence = lerpf(ik.influence, inactive_ik_influence, ik_lerp_speed * delta)
		return 0.0

	var avg_hit_y: float

	if ray_f.is_colliding() and ray_b.is_colliding():
		var w_f: float = front_ray_weight
		var w_b: float = 1.0 - front_ray_weight

		avg_hit_y = (ray_f.get_collision_point().y * w_f) + (ray_b.get_collision_point().y * w_b)
	elif is_f_colliding:
		avg_hit_y = ray_f.get_collision_point().y
	else:
		avg_hit_y = ray_b.get_collision_point().y

	var height_diff: float = avg_hit_y - global_position.y

	var current_pos_y: float = 0.0

	if height_diff > slope_threshold:
		# 1. Climbing up
		current_pos_y = pos_y_height_up
	elif height_diff < -slope_threshold:
		# 2. Climbing down
		current_pos_y = pos_y_height_down
	else:
		# 3. Walk on flat surface
		current_pos_y = pos_y_height_flat

	target_marker.global_position.y = avg_hit_y + current_pos_y

	ik.influence = lerpf(ik.influence, active_ik_influence, ik_lerp_speed * delta)

	return height_diff
