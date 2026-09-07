extends AudioStreamPlayer3D
@onready var character: CharacterBody3D = get_parent()


func PlayFootstep() -> void:
	if not character.is_on_floor():
		return
	
	for i in character.get_slide_collision_count():
		var col :KinematicCollision3D = character.get_slide_collision(i)
		
		if col.get_normal() == character.get_floor_normal():
			var collider :Object = col.get_collider()
			if collider is GroundSound:
				var info :GroundSound = collider
				stream = info.footstep_sound
				break
	
	play()
