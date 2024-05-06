extends Node

class GameLevel:
	var players = []

	var enemies = []

	func add_player(new_player):
		players.push_back(new_player)

	func add_enemy(new_enemy):
		enemies.push_back(new_enemy)
