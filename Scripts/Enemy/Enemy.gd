class_name Enemy
extends CharacterBody3D

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var enemyState: EnemeyState = $StateMachine
@onready var playerCast: ShapeCast3D = $PlayerShape3D
@onready var hit_box: ShapeCast3D = $HitBox


@export var moveSpeed: float = 3
@export var rotateSpeed: float = 0.1

var targetPositon: Vector3
var hasTarget: bool = false
var player: Player

#Current state that our enemy is
var state: BaseEnemyState 

func _ready() -> void:
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
	
	if playerCast.is_colliding():
		player = playerCast.get_collider(0) as Player
	else:
		player = null

	
func Move(delta: float) -> void:
	navigation_agent_3d.target_position = targetPositon
	var nextPathPosition: Vector3 = navigation_agent_3d.get_next_path_position()
	var direction: Vector3 = global_position.direction_to(nextPathPosition)
	velocity = direction * moveSpeed
	
	var rotSpeed = rotateSpeed
	var targetRotation: float = direction.signed_angle_to(Vector3.MODEL_FRONT, Vector3.DOWN)
	if abs(targetRotation - rotation.y) > deg_to_rad(60):
		rotSpeed = rotateSpeed * 4
	#rotation.y = move_toward(rotation.y , targetRotation, delta * moveSpeed)
	var yaw: = atan2(direction.x, direction.z)
	yaw = lerp_angle(rotation.y, yaw, rotSpeed)
	
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
