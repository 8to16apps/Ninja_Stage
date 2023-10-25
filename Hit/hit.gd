#Simple script that spawn for 0.25 second
#and play one random hit audio
extends Sprite2D

@onready var streams:Array[AudioStream] = [preload("res://Hit/sfx/impact-1.ogg"), preload("res://Hit/sfx/impact-2.ogg")]
func _ready():
	$sfx.stream = streams.pick_random()
	$sfx.play()
	get_tree().create_timer(0.25).timeout.connect(func(): queue_free())

