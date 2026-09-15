class_name Enemy
extends CharacterBody3D

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var enemyState: EnemeyState = $StateMachine
@onready var playerCast: ShapeCast3D = $PlayerShape3D
@onready var hit_box: ShapeCast3D = $HitBox
@onready var beam: MeshInstance3D = $Beam


@export var moveSpeed: float = 3
@export var rotateSpeed: float = 0.1
@export var damage: float = 5
@export var attackRange: float = 5

var targetPositon: Vector3
var hasTarget: bool = false
var player: Player

#Current state that our enemy is
var state: BaseEnemyState 

func _ready() -> void:
	beam.visible = false
	state = enemyState.Idle
	state.Enter(self)
	
func _physics_process(delta: float) -> void:
	state.PreUpdate(self)
	state.Update(self, delta)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if hasTarget:
		Move(delta)
	else:
		velocity = Vector3.ZERO
	move_and_slide()
	
	
func Move(delta: float) -> void:
	navigation_agent_3d.target_position = targetPositon
	var nextPathPosition: Vector3 = navigation_agent_3d.get_next_path_position()
	var direction: Vector3 = global_position.direction_to(nextPathPosition)
	velocity = direction * moveSpeed
	
	var rotSpeed = rotateSpeed
	var targetRotation: float = direction.signed_angle_to(Vector3.MODEL_FRONT, Vector3.DOWN)
	if abs(targetRotation - rotation.y) > deg_to_rad(60):
		rotSpeed = rotateSpeed * 4
	TurnTo(direction, rotSpeed)

func TurnTo(direction: Vector3, speed: float) -> void:
	if direction:
		var yaw: = atan2(direction.x, direction.z)
		yaw = lerp_angle(rotation.y, yaw, 0.25)
		rotation.y = yaw
	
func ChangeStateTo(nextState: BaseEnemyState) -> void:
	state.Exit(self)
	state = nextState
	state.Enter(self)

func ifThereIsWall(player: Vector3) -> bool:
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(position, player, 1 << 6, [self])
	var result = space_state.intersect_ray(query)
	return !result.is_empty()
