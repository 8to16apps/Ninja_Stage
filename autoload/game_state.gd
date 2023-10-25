#This is the Model in a MVC system
#All the data needed and controled by several points are here
extends Node

signal state_change
signal hud_change

var stages_data:StageData = preload("res://data/stages_data.tres")

var points:int = 0
var stage_level:int = 0
var lifes:int = 3
var ninja_dead:int = 0

func reset():
	points = 0
	stage_level = 0
	lifes = 3
	ninja_dead = 0
	hud_change.emit()


func add_points(p:int):
	points = max(points + p,0)
	hud_change.emit()


func next_stage():
	stage_level = min(stage_level + 1, 9)
	ninja_dead = 0
	state_change.emit()


func hit_player():
	lifes -= 1
	hud_change.emit()

func add_dead_ninja():
	ninja_dead += 1
	hud_change.emit()


func reset_stage():
	ninja_dead = 0
	hud_change.emit()
