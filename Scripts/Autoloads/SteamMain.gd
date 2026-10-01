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
	
func SetAchievement(ach) -> void:
	var status = Steam.getAchievement(ach)
	if status["achieved"]:
		print("Already Unlocked")
		return
	Steam.setAchievement(ach)
