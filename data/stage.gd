#The basic data for configure a stage
#this is used as an array by the stage_data resource

class_name Stage extends Resource

@export var number_of_ninjas:int = 10
@export var spawn_delay:float = 5
@export var types_probability:Array[int] = [100,0,0] #probability of spawn some type of ninja
@export var distance_probability:Array[int] = [100,0] #probability of spawn in some distance [far,mid]
@export var jump_probability:Array[int] = [25, 5] #probability of jump forwar when distance [far,mid]
