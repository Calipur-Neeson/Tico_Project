class_name CameraControl
extends SpringArm3D

@onready var camera: Camera3D = get_node("Camera3D")
@export var springLength: float = 2
@export var rotateRate: float = 150
@export var mouseSensitivity: float = .1
@export var camHeightStand: float = 0.7
@export var camHeightCrouch: float = 0.4
var mouseInput: Vector2
@onready var player: Node3D = get_parent()
@onready var camRig: Vector3 = Vector3(0, 0.7, 0)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spring_length = springLength
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var lookInput : Vector2 = Input.get_vector("View_Right","View_Left","View_Down","View_Up")
	lookInput = rotateRate * delta * lookInput
	lookInput -= mouseInput
	mouseInput = Vector2.ZERO
	
	rotation_degrees.x += lookInput.y
	rotation_degrees.y += lookInput.x
	rotation_degrees.x = clampf(rotation_degrees.x, -70, 50)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouseInput = event.relative * mouseSensitivity
	elif event is InputEventKey and event.keycode == KEY_ESCAPE and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	position = player.position + player.global_basis * camRig

func ResetCamera(delta: float) -> void:
	camRig.x = lerpf(camRig.x, 0, 10 * delta)
	camRig.y = lerpf(camRig.y, camHeightStand, 10 * delta)
	spring_length = lerpf(spring_length, springLength, 10 * delta)
