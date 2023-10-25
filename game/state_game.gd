#A state in the state machine that setup all the nodes for
#play the game and control when to change to other state

extends "res://state_machine/State.gd"

@onready var game_layer:CanvasLayer = $GameLayer
@onready var game_music:AudioStreamPlayer = $GameLayer/game_music
@onready var game:Game = $GameLayer/Game


func _ready():
	game_layer.visible = false
	game.ninja_punch.connect(func(type:int): state_machine.transition_to("ninja_punch", {"type":type}))
	game.stage_clear.connect(func(): state_machine.transition_to("stage_clear"))


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	game_layer.visible = true
	game.start_stage()
	game_music.play()


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	game_layer.visible = false
	game_music.stop()
