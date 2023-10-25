#A simple class to make hit noise random easy

class_name AudioMng extends AudioStreamPlayer

var ninja_scream:Array[AudioStream] = [preload("res://ninja/sfx/scream-1.ogg"), preload("res://ninja/sfx/scream-2.ogg"), preload("res://ninja/sfx/scream-3.ogg"), preload("res://ninja/sfx/scream-4.ogg"), preload("res://ninja/sfx/scream-5.ogg"), preload("res://ninja/sfx/scream-6.ogg")]

func ninja_hitted():
	if playing: return
	
	var audioStream:AudioStream = ninja_scream.pick_random()
	stream = audioStream
	play()
