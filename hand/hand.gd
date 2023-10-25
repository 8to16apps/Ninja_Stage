#Simple node that control the position of the shuriken that point the hand position
#and send the shoot signal when the player press the shoot action

extends Node2D

signal shoot(position:Vector2)

@export var speed:float = 250.0
@export var spawn_limit:int = 10

@onready var shuriken:Sprite2D = $shuriken
@onready var sfx = $sfx


# Called when the node enters the scene tree for the first time.
func _ready():
	reset_game()


func reset_game():
	global_position = Vector2(512.0, 576.0)


func _process(_delta):
	global_position.x = clamp(get_global_mouse_position().x, 0.0, 1024.0)
	
	shuriken.modulate = Color.WHITE if (Shuriken.number_of_shurikens < spawn_limit) else Color(1.0,1.0,1.0,0.5)


func _unhandled_input(event):
	if event.is_action_pressed("shoot") and Shuriken.number_of_shurikens < spawn_limit:
		if not sfx.playing:
			sfx.play()
		shoot.emit(global_position)
