class_name BaseInteractable
extends Node3D

@export var outLine: ShaderMaterial
@onready var mesh: MeshInstance3D = $Mesh

var mat: Material

func _ready() -> void:
	mat = mesh.get_active_material(0) as StandardMaterial3D
	if mat:
		mat.next_pass = null

func Interact(player: Player) -> void:
	print("Press E")

func InteractEnter() -> void:
	if mat:
		mat.next_pass = outLine

func InteractExit() -> void:
	if mat:
		mat.next_pass = null
