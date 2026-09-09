extends Node3D

@export var detecteRange = 10
func _ready() -> void:
	SoundEmitter.sound_emitted.connect(OnSoundDetected)


func OnSoundDetected(source: Vector3, volume: float) -> void:
	var distance: float = global_position.distance_to(source)
	if distance > detecteRange:
		return
	 
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(position, source, 1 << 6, [self])

	var result = space_state.intersect_ray(query)
	#print(result.is_empty())
	#print("enemy", global_position)
	#print("player", source)
	
