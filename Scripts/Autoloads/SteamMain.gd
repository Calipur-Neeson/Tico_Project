extends Node

var appID = "480"

func _init() -> void:
	OS.set_environment("SteamAppID", appID)
	OS.set_environment("SteamGameID", appID)
	
func _ready() -> void:
	Steam.steamInit()
	var isRuning = Steam.isSteamRunning()
	
	if !isRuning:
		print("Error: Steam is not running")
	else :
		print("Steam is Running")
	
	var id = Steam.getSteamID()
	var name = Steam.getFriendPersonaName(id)
	print("Username: ", str(name))
