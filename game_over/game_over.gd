#A state in the state machine that setup all the nodes for
#the game over screen and wait until the player shoot to go to the main title

extends "res://state_machine/State.gd"

@onready var game_over_layer:CanvasLayer = $gameOverLayer
@onready var player_lose:AudioStreamPlayer = $gameOverLayer/Player_lose
@onready var game_over_anim:AnimationPlayer = $gameOverLayer/game_over_anim

@export var allow_continue:bool = false

func _ready():
	game_over_layer.visible = false


# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("shoot") and allow_continue:
		get_viewport().set_input_as_handled()
		state_machine.transition_to("title")


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	get_tree().paused = true
	game_over_layer.visible = true
	game_over_anim.play("enter")
	player_lose.play()


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	game_over_layer.visible = false
	game_over_anim.stop()
	player_lose.stop()


#Goto the artist in credits
func _on_imagen_credit_meta_clicked(meta):
	OS.shell_open(str(meta))
