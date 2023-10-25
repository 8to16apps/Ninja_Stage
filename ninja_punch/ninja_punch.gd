#A state in the state machine that setup all the nodes for
#ninja reach the player position and reset the level
#the audio is controled by animation

extends "res://state_machine/State.gd"

@onready var ninja_layer = $ninjaLayer
@onready var ninja_win = $ninjaLayer/Ninja_win
@onready var ninja_punch_anim = $ninjaLayer/ninja_punch_anim
@onready var press_shoot = $ninjaLayer/press_shoot
@onready var sprite_2d = $ninjaLayer/Sprite2D

var allow_transition:bool = false

func _ready():
	ninja_layer.visible = false
	press_shoot.visible = false


# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("shoot") and allow_transition:
		get_viewport().set_input_as_handled()
		if GameState.lifes > 0:
			state_machine.transition_to("game")
		else:
			state_machine.transition_to("game_over")


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	get_tree().paused = true
	allow_transition = false
	ninja_layer.visible = true
	press_shoot.visible = false
	sprite_2d.frame = (_msg["type"] * 3) + 1
	ninja_punch_anim.play("enter")


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	ninja_layer.visible = false
	press_shoot.visible = false
	ninja_win.stop()
	ninja_punch_anim.stop()
	get_tree().paused = false


#called by animation
func _on_ninja_win_finished():
	GameState.hit_player()
	allow_transition = true
	press_shoot.visible = true

