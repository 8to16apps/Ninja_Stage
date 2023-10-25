#A class that move and control the colision with the shurikens
class_name Ninja extends Area2D

#Keep track of the spawned ninjas
static var Number_of_ninjas:int = 0

signal hit_the_player(type:int)
signal dead

#Some states of the ninja
#can be touch in the inspector
#A designer can touch without touch the code
@export var dis_scale:Array[Vector2] = [Vector2(0.2,0.2), Vector2(0.3,0.3), Vector2(1,1)]
@export var dis_y_coor:Array[float] = [132.0, 332.0, 576.0]
@export var change_direction_delay:float = 2.0
@export var speed:Array[float] = [750.0, 1000.0, 750.0]


#Some nodes
@onready var jump_audio:Array[AudioStream] = [preload("res://ninja/sfx/woosh-1.ogg"), preload("res://ninja/sfx/woosh-2.ogg"), preload("res://ninja/sfx/woosh-3.ogg")]
@onready var ninja_sprite:Sprite2D = $Ninja
@onready var collision = $collision

#The state of this ninja
var type:int = 0
var distance:int = 0
var direction:Vector2 = Vector2.ZERO
var current_direction_delay:float = 0.0
var movement_pattern:Array[int] = [0]

const direction_x:Array[float] = [-1.0,0.0,1.0]

#Set the sprites by the type and distance
func _ready():
	reset_pattern()
	
	scale = dis_scale[distance]
	ninja_sprite.frame = (type * 3) + int(direction.x + 1.0)
	current_direction_delay = change_direction_delay
	
	#Add to the static counter
	Number_of_ninjas += 1

#substract from the static counter
func _exit_tree():
	Number_of_ninjas -= 1

#Generate a movement pattern array
#with the code to move:
#0 = left
#1 = jump forward
#2 = right
#The proportion is controled by the stage data
func reset_pattern():
	current_direction_delay = 0
	var current_stage = GameState.stages_data.stages[GameState.stage_level]
	var jumps:int = current_stage.jump_probability[distance]
	var lefts:int = int( (100.0 - jumps) / 2.0 )
	
	for i in 100:
		if i < jumps:
			movement_pattern.append(1)
		elif i < (jumps + lefts):
			movement_pattern.append(0)
		else:
			movement_pattern.append(2)
	
	movement_pattern.shuffle()
	
	#Not allow jump in the first movement
	while movement_pattern[0] == 1:
		var t = movement_pattern.pop_front()
		movement_pattern.push_back(t)

#Move the ninja
func _physics_process(delta):
	global_position = global_position + direction * (speed[type] * dis_scale[distance].x) * delta
	
	if global_position.x < (-265.0 * dis_scale[distance].x):
		global_position.x = 1024.0 + (265.0 * dis_scale[distance].x)
	
	if global_position.x > 1024 + (265.0 * dis_scale[distance].x):
		global_position.x = (-265.0 * dis_scale[distance].x)
	
	current_direction_delay -= delta
	if current_direction_delay < 0.0: #change to the next type of movement
		current_direction_delay = change_direction_delay
		var new_dir:int = 1
		if movement_pattern.size() > 0:
			new_dir = movement_pattern.pop_front()
		
		direction = Vector2(direction_x[new_dir], 0.0)
		ninja_sprite.frame = (type * 3) + new_dir
		
		if new_dir == 1: #jump_forward
			var audio:AudioStream = jump_audio.pick_random()
			$sfx.stream = audio
			$sfx.play()
			distance += 1
			if distance == 2:
				await get_tree().create_timer(0.25).timeout
				global_position = Vector2(512.0, 576.0)
				scale = dis_scale[distance]
				hit_the_player.emit(type)
				set_physics_process(false)
			else:
				if type == 2: #Teleport
					global_position = Vector2(global_position.x,dis_y_coor[distance])
					scale = dis_scale[distance]
					reset_pattern()
				else:
					#Jump animation
					var tween = create_tween()
					tween.tween_callback(func(): collision.disabled = true)
					tween.tween_property(self, "global_position", Vector2(global_position.x,dis_y_coor[distance]), 0.25).\
						set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK) #this mae the movement look "realistic"
					
					tween.set_parallel(true).tween_property(self, "scale", dis_scale[distance], 0.25)
					tween.set_parallel(false).tween_callback(reset_pattern)
					tween.tween_callback(func(): collision.disabled = false)


#control when colide with a shuriken
func _on_area_entered(area):
	if area is Shuriken:
		area.queue_free()
		
		GameState.add_points(10 * (type + 1))
		queue_free()
		dead.emit()
