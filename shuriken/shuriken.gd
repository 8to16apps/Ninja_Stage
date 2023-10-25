#Simple class move the shuriken upward and change the scale
#by their position. When reach the limit is destroyed

class_name Shuriken extends Area2D

static var number_of_shurikens:int = 0

signal hit_or_remove(p:Vector2, s:Vector2)

#Some data that can be touch in the inspector
@export var target_scale := Vector2(0.2,0.2)
@export var target_y:float = 68.0
@export var speed:float = 250.0
@export var scale_speed:float = 0.55

var scale_step:float = 0.0

func _ready():
	number_of_shurikens += 1


func _exit_tree():
	number_of_shurikens -= 1


func _physics_process(delta):
	global_position = global_position + Vector2(0.0,-1.0) * speed * delta
	
	scale_step += scale_speed * delta
	scale = lerp(Vector2(1.0,1.0), target_scale, scale_step)
	
	if global_position.y <= target_y:
		hit_or_remove.emit(global_position, scale)
		queue_free()
