class_name PlayerDieState
extends BasePlayerState


func Enter(player: Player) -> void:
	player.animation_tree.active = false
	player.velocity = Vector3.ZERO
	player.physical_bone_simulator_3d.physical_bones_start_simulation()
	#SceneLoader.LoadScene(SceneLoader.mainMenuScene)
