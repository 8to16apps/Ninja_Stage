#Tha game class that add and remove the other objects
#Like spawn ninja scenes by the current stage data
#Spawn surikens by the hand scene shoot signal
#spawn hit scenes when shuriken is destroyed by position
#Play ninja hit sound
#signal the state_game when the player clear the stage
#or when a ninja reach the player position

class_name Game extends Node2D

signal stage_clear
signal ninja_punch(type:int)

#Packed scenes to be spawned
@export var shuriken_prefab:PackedScene
@export var ninja_prefab:PackedScene
@export var hit_prefab:PackedScene

#Containers and markers
@onready var ninjas:Node2D = $ninjas
@onready var y_marker:Array[Marker2D] = [$left_far_y_marker, $left_mid_y_marker, $right_far_y_marker, $right_mid_y_marker]
@onready var ninja_hit:AudioMng = $"../Ninja_hit"

#Current stage data
var current_stage:Stage = null
var current_spawn_type:Array[int] = []
var current_spawn_distance:Array[int] = []
var current_spanw_ninja_delay := 0.0
var current_spanw_ninja_idx:int = -1


func start_stage():
	current_stage = GameState.stages_data.stages[GameState.stage_level]
	current_spawn_type.clear()
	current_spawn_distance.clear()
	current_spanw_ninja_delay = 0.0
	current_spanw_ninja_idx = 0
	
	#Weighted probability
	#Fill a array with as much elements of a values as the weight of the probability
	for i in current_stage.types_probability.size():
		for _t in current_stage.types_probability[i]:
			current_spawn_type.append(i)
	current_spawn_type.shuffle()
	
	for j in current_stage.distance_probability.size():
		for _t in current_stage.distance_probability[j]:
			current_spawn_distance.append(j)
	current_spawn_distance.shuffle()
	
	#Reset the game data and remove all remain objects
	GameState.reset_stage()
	ninja_hit.stop()
	get_tree().call_group("Ninja", "queue_free")


func _process(delta):
	if current_spanw_ninja_idx >= current_stage.number_of_ninjas:
		if Ninja.Number_of_ninjas <= 0:
			stage_clear.emit()
		return
	
	#control the rate of ninja spawning
	current_spanw_ninja_delay -= delta
	if current_spanw_ninja_delay <= 0.0:
		current_spanw_ninja_delay = current_stage.spawn_delay
		current_spanw_ninja_idx += 1
		if current_spanw_ninja_idx < current_stage.number_of_ninjas:
			spawn_ninja(current_spawn_type[current_spanw_ninja_idx], randi()%2, current_spawn_distance[current_spanw_ninja_idx])


#Connected to the hand shoot signal by inspector
func _on_hand_shoot(p:Vector2):
	var new_shuriken:Shuriken = shuriken_prefab.instantiate()
	new_shuriken.global_position = p
	new_shuriken.hit_or_remove.connect(spawn_hit)
	ninjas.add_child(new_shuriken)


#create a ninja scene and add it to the playfield
func spawn_ninja(type:int, right:int, dis:int):
	var new_ninja:Ninja = ninja_prefab.instantiate() as Ninja
	new_ninja.type = type
	var idx:int = (right * 2) + dis
	new_ninja.global_position = y_marker[ idx ].global_position
	new_ninja.direction = Vector2(1.0 - (2.0 * right), 0.0)
	new_ninja.distance = dis
	new_ninja.hit_the_player.connect(hit_player)
	new_ninja.dead.connect(dead_ninja)
	ninjas.add_child(new_ninja)


#nitify that a ninja is dead
func dead_ninja():
	ninja_hit.ninja_hitted()
	GameState.add_dead_ninja()


#spanw a hit scene when a shuriken reach its limit
func spawn_hit(p:Vector2, s:Vector2):
	var new_hit:Node2D = hit_prefab.instantiate()
	new_hit.global_position = p
	new_hit.scale = s
	ninjas.add_child(new_hit)


#A ninja reach the player position
func hit_player(type:int):
	ninja_punch.emit(type)
