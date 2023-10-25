#View of the data in game_state autoload
#connect with the state_change and hud_change signals
#and apply to the visual controls

class_name GameHUD extends Control

@onready var lifes:Array[ColorRect] = [$Lifes/HBoxContainer/Life0, $Lifes/HBoxContainer/Life1, $Lifes/HBoxContainer/Life2]
@onready var stage:Label = $Stage
@onready var points:Label = $Points
@onready var stage_progress:ProgressBar = $Stage/stage_progress

var current_stage:Stage = null

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.state_change.connect(state_change)
	GameState.hud_change.connect(hud_change)
	
	state_change()
	hud_change()


func state_change():
	current_stage = GameState.stages_data.stages[GameState.stage_level]
	stage_progress.max_value = current_stage.number_of_ninjas


func hud_change():
	for i in lifes.size():
		lifes[i].visible = (i < GameState.lifes)
	
	stage.text = "Stage: {0}".format([GameState.stage_level + 1])
	points.text = str(GameState.points)
	stage_progress.value = GameState.ninja_dead
