class_name HeatSystem
extends Node3D

@export var maxHeatMeter: float = 100
@export var dropSpeed: float = 5

@onready var player: Player = get_parent()
@onready var progress_bar: ProgressBar = $CanvasLayer/Panel/ProgressBar
@onready var csg_polygon_3d: CSGPolygon3D = $"../Character/Y Bot/Skeleton3D/BoneAttachment3D/Path3D/CSGPolygon3D"
@onready var texture_progress_bar: TextureProgressBar = $SubViewport/TextureProgressBar


var currentHeat: float
var isIntervene: bool = false

func _ready() -> void:
	currentHeat = maxHeatMeter
	progress_bar.max_value = maxHeatMeter
	progress_bar.value = maxHeatMeter

func _process(delta: float) -> void:
	if !isIntervene:
		currentHeat -= dropSpeed * delta
	
	currentHeat = clampf(currentHeat, 0, maxHeatMeter)
	#For 2D bar
	progress_bar.value = currentHeat
	#For 2D bar in 3D world
	texture_progress_bar.value = currentHeat
	#For 3D spine bar
	var percentage := currentHeat / maxHeatMeter * 3.11
	csg_polygon_3d.material.set_shader_parameter("percent", percentage)
	
	
	if currentHeat <= 0:
		player.ChangeStateTo(player.playerState.Die)

func InterveneHeat(value: float, delta: float) -> void:
	isIntervene = true
	currentHeat += value
