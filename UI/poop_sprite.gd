extends CharacterBody2D

var spawn_pos : Vector2
var zdex : int

func _ready():
	global_position = spawn_pos
	z_index = zdex
