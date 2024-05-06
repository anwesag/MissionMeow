extends Node2D
# Singleton instance
static var instance

func _ready():
	# Assign the singleton instance
	instance = self

var players = []
var enemies = []

func add_player(new_player):
	players.push_back(new_player)

func add_enemy(new_enemy):
	enemies.push_back(new_enemy)
