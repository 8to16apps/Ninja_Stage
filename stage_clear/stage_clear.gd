#A state in the state machine that setup all the nodes for
#the stage clear screen, and wait to player input to jump to the next stage

extends "res://state_machine/State.gd"

@onready var stage_clear_layer:CanvasLayer = $stageClearLayer
@onready var ninja_lose:AudioStreamPlayer = $stageClearLayer/Ninja_lose
@onready var stage_clear_anim:AnimationPlayer = $stageClearLayer/stage_clear_anim

func _ready():
	stage_clear_layer.visible = false

# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("shoot") and not ninja_lose.playing:
		get_viewport().set_input_as_handled()
		state_machine.transition_to("game")


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	get_tree().paused = true
	stage_clear_layer.visible = true
	ninja_lose.play()
	stage_clear_anim.play("enter")


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	GameState.next_stage()
	stage_clear_layer.visible = false
	ninja_lose.stop()
	stage_clear_anim.stop()
	get_tree().paused = false
