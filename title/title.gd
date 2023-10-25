#A state in the state machine that setup all the nodes for
#the title screen and wait to player interaction to go to game

extends "res://state_machine/State.gd"

@onready var hud_layer = $HUDLayer

@onready var title_layer = $TitleLayer
@onready var title_music:AudioStreamPlayer = $TitleLayer/titleMusic
@onready var title_anim:AnimationPlayer = $TitleLayer/title_anim

func _ready():
	title_layer.visible = false

# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("shoot") and not title_anim.is_playing():
		get_viewport().set_input_as_handled()
		state_machine.transition_to("game")


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	get_tree().paused = true
	hud_layer.visible = false
	title_layer.visible = true
	title_music.play()
	title_anim.play("title_enter")


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	hud_layer.visible = true
	title_layer.visible = false
	title_music.stop()
	title_anim.stop()
	GameState.reset()
	get_tree().paused = false


#Goto the artist in credits
func _on_imagen_credit_meta_clicked(meta):
	OS.shell_open(str(meta))
