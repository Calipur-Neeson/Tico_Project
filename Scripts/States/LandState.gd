class_name PlayerLandState
extends BasePlayerState

var landDirection: Vector3
var landVelociry: Vector3

var isLand: bool
var isHardLand: bool
var isLandRoll: bool

var time: float

func Enter(player: Player) -> void:
	time = 0
	player.island = false
	#print("landSpeed", player.landSpeed)
	if player.landSpeed <= -12:
		if player.GetMoveInput():
			landDirection = player.GetMoveInput()
			landVelociry = player.velocity
			landVelociry.y = 0
			
			isLandRoll = true
			player.animation_tree.set("parameters/movement/transition_request", "landRoll")
		else :
			isHardLand = true
			player.animation_tree.set("parameters/movement/transition_request", "hardLand")
	elif player.landSpeed <= -7:
		isLand = true
		player.animation_tree.set("parameters/movement/transition_request", "land")
	else:
		player.ChangeStateTo(PlayerState.Idle)

	player.jumpSpeed = 0

func PreUpdate(player: Player) -> void:
	if isLand and time > 0.7:
		player.ChangeStateTo(PlayerState.Idle)
	elif isHardLand and time > 2:
		player.ChangeStateTo(PlayerState.Idle)
	elif isLandRoll and time > 1.8:
		player.ChangeStateTo(PlayerState.Idle)


func Update(player: Player, delta: float) -> void:
	time += delta
	if isLandRoll:
		player.ApplyRootMotion(delta)
		
