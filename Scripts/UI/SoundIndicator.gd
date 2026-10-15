class_name SoundIndicator
extends Node3D

@onready var color_rect: ColorRect = $SubViewport/ColorRect
@onready var shader_material: ShaderMaterial = color_rect.material
@onready var shaderParameter_sounds: CurveTexture = shader_material.get_shader_parameter("sounds")

var soundTween: Tween

enum sm{IDLE, CROUCH, CROUCHWALK}
var state: = sm.IDLE

func _ready() -> void:
	SoundEmitter.sound_emitted.connect(OnSoundEmit)

func _process(delta: float) -> void:
	match state:
		sm.IDLE:
			MoveIdle(delta)
		sm.CROUCH:
			MoveCrouchIdle(delta)
		sm.CROUCHWALK:
			MoveCrouchWalk(delta)
	
func OnSoundEmit(source: Vector3, volume: float) -> void:
	var value = remap(volume, 0.0, 5.0, 0.2, 2.0)
	
	if soundTween and soundTween.is_running():
		soundTween.kill()

	soundTween = create_tween()
	soundTween.tween_method(SetCurveValue, shaderParameter_sounds.curve.get_point_position(0).y, value, 0.2)
	soundTween.tween_method(SetCurveValue, value, 0.2, 0.2)

func SetCurveValue(value: float) -> void:
	shaderParameter_sounds.curve.set_point_value(0.5, value)
	
func SetCurveColor(color: Color) -> void:
	shader_material.set_shader_parameter("foreground", color)

func MoveIdle(delta: float) -> void:
	position = lerp(position, Vector3(0, 0, 0), delta * 10)
func MoveCrouchIdle(delta: float) -> void:
	position = lerp(position, Vector3(-0.06, -0.7, -0.47), delta * 10)
func MoveCrouchWalk(delta: float) -> void:
	position = lerp(position, Vector3(0.16, -0.235, -0.3), delta * 10)
