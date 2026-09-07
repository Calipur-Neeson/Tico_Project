class_name HeatSystem
extends Node3D

@export var maxHeatMeter: float = 100
@export var dropSpeed: float = 5
var healSpeed: float = 10

@onready var player: Player = get_parent()
@onready var progress_bar: ProgressBar = $CanvasLayer/Panel/ProgressBar
@onready var csg_polygon_3d: CSGPolygon3D = $"../Character/Y Bot/Skeleton3D/BoneAttachment3D/Path3D/CSGPolygon3D"


var currentHeat: float
var isDroping: bool = true

func _ready() -> void:
	currentHeat = maxHeatMeter
	progress_bar.max_value = maxHeatMeter
	progress_bar.value = maxHeatMeter

func _process(delta: float) -> void:
	if isDroping:
		currentHeat -= dropSpeed * delta
	else:
		currentHeat += healSpeed * delta
	
	currentHeat = clampf(currentHeat, 0, maxHeatMeter)
	progress_bar.value = currentHeat
	
	var percentage := currentHeat / maxHeatMeter * 5.5

	csg_polygon_3d.material.set_shader_parameter("percent", percentage)
	
	if currentHeat <= 0:
		player.ChangeStateTo(player.playerState.Die)
