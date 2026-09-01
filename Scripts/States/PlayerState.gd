extends Node

var Idle := PlayerIdleState.new()
var Walk := PlayerWalkState.new()
var Run := PlayerRunState.new()
var Jump := PlayerJumpState.new()
var RunJump := PlayerRunJumpState.new()
var Fall := PlayerFallState.new()
var Land := PlayerLandState.new()
var CrouchIdle := PlayerCrouchIdleState.new()
var CrouchWalk := PlayerCrouchWalkState.new()
var HangingIdle := PlayerHangingIdleState.new()
var HangingToJump := PlayerHangingToJumpState.new()

var LeftShimmy := PlayerLeftShimmyState.new()
var RightShimmy := PlayerRightShimmyState.new()
var ClimbWall := PlayerClimbWallState.new()
var Aim := PlayerAimState.new()
var Vault: = PlayerVaultState.new()

var TurnLeftShimmy := PlayerLeftShimmyTurnState.new()
var TurnRightShimmy := PlayerRightShimmyTurnState.new()
