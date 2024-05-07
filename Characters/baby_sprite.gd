extends CharacterBody2D

@onready var player = GameManager.players[0]
@onready var current_agent_position = global_position
@onready var player_distance_vector = player.position - current_agent_position


func _physics_process(_delta):
	player = GameManager.players[0]
	current_agent_position = global_position
	player_distance_vector = player.position - current_agent_position

func _input(event):
	if event.is_action_pressed("meow"):
		if player_distance_vector.length() <= 100:
			player.update_health(20)
		
