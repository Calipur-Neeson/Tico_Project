class_name PlayerDieState
extends BasePlayerState

var time : float

func Enter(player: Player) -> void:
	time = 0
	player.animation_tree.active = false
	player.velocity = Vector3.ZERO
	player.physical_bone_simulator_3d.physical_bones_start_simulation()

func PreUpdate(player: Player) -> void:
	if time > 1:
		SceneLoader.LoadScene(SceneLoader.mainMenuScene)
		
func Update(player: Player, delta: float) -> void:
	time += delta
