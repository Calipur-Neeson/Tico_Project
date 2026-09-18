extends Node3D

@onready var enemy: Enemy = get_parent()

@export var detecteRange: float = 10
@export var alarmVolum: float = 1.5

func _ready() -> void:
	SoundEmitter.sound_emitted.connect(OnSoundDetected)


func OnSoundDetected(source: Vector3, volume: float) -> void:
	var distance: float = global_position.distance_to(source)
	if distance > detecteRange:
		return
	 
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(position, source, 1 << 6, [self])

	var result = space_state.intersect_ray(query)
	
	if CaculateVolum(volume, distance, !result.is_empty()) > alarmVolum and enemy.state != EnemyChaseState:
		enemy.targetPositon = source
		enemy.navigation_agent_3d.target_position = source
		enemy.ChangeStateTo(enemy.enemyState.Alarm)
	#print(result.is_empty())
	#print("enemy", global_position)
	#print("player", source)
	
func CaculateVolum(sourceVolum: float, dis: float, isBlock: bool) -> float:
	if isBlock:
		sourceVolum *= 0.5
	
	var heardVolum: float = sourceVolum - (sourceVolum / detecteRange) * dis
	return heardVolum
