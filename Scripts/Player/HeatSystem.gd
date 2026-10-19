class_name HeatSystem
extends Node3D

@export var maxHeatMeter: float = 100
@export var dropSpeed: float = 5

@onready var player: Player = get_parent()
@onready var progress_bar: ProgressBar = $CanvasLayer/Panel/ProgressBar
@onready var csg_polygon_3d: CSGPolygon3D = $"../Character/Y Bot/Skeleton3D/BoneAttachment3D/Path3D/CSGPolygon3D"
@onready var texture_progress_bar: TextureProgressBar = $SubViewport/TextureProgressBar


var currentHeat: float
var heatInfluence: float = 1
var isDie: bool = false

enum sm{IDLE, CROUCH, CROUCHWALK}
var state: = sm.IDLE
		
func _ready() -> void:
	currentHeat = maxHeatMeter
	progress_bar.max_value = maxHeatMeter
	progress_bar.value = maxHeatMeter
	isDie = false

func _process(delta: float) -> void:
	if not GameManager.currentGameState == GameManager.GameState.PLAYING:
		return
		
	currentHeat -= dropSpeed * delta
	heatInfluence = log(remap(currentHeat / maxHeatMeter, 0, 1, 1.4, exp(1)))
	
	currentHeat = clampf(currentHeat, 0, maxHeatMeter)
	#For 2D bar
	progress_bar.value = currentHeat
	#For 2D bar in 3D world
	texture_progress_bar.value = currentHeat
	#For 3D spine bar
	var percentage := currentHeat / maxHeatMeter * 3.11
	csg_polygon_3d.material.set_shader_parameter("percent", percentage)
	
	if currentHeat <= 0 and !isDie:
		isDie = true
		player.ChangeStateTo(player.playerState.Die)
	
	match state:
		sm.IDLE:
			MoveIdle(delta)
		sm.CROUCH:
			MoveCrouchIdle(delta)
		sm.CROUCHWALK:
			MoveCrouchWalk(delta)

func InterveneHeat(value: float, delta: float) -> void:
	currentHeat += value * delta

func MoveIdle(delta: float) -> void:
	position = lerp(position, Vector3(0, 0, 0), delta * 10)
func MoveCrouchIdle(delta: float) -> void:
	position = lerp(position, Vector3(-0.1, -0.7, -0.47), delta * 10)
func MoveCrouchWalk(delta: float) -> void:
	position = lerp(position, Vector3(0.24, -0.245, -0.35), delta * 10)
