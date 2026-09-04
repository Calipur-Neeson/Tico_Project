extends Node

signal progressChanged(progress)
signal loadFinished

var loadingScene: PackedScene = preload("uid://c5u3xklskdd5s")
var loadedResource: PackedScene
var scenePath: String
var progress: Array = []
var useThreads: bool = true

func _ready() -> void:
	set_process(false)


func LoadScene(path: String) -> void:
	scenePath = path
	
	var newLoadScene = loadingScene.instantiate()
	add_child(newLoadScene)
	progressChanged.connect(newLoadScene.OnProgressChanged)
	loadFinished.connect(newLoadScene.OnLoadFinished)
	
	await  newLoadScene.LoadingSceneReady
	
	StartLoad()
	
func StartLoad() -> void:
	var state = ResourceLoader.load_threaded_request(scenePath, "", useThreads)
	if state == OK:
		set_process(true)
		
func  _process(delta: float) -> void:
	var loadStatus = ResourceLoader.load_threaded_get_status(scenePath, progress)
	progressChanged.emit(progress[0])
	match loadStatus:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
			set_process(false)
		ResourceLoader.THREAD_LOAD_LOADED:
			loadedResource = ResourceLoader.load_threaded_get(scenePath)
			get_tree().change_scene_to_packed(loadedResource)
			loadFinished.emit()
