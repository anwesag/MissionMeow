extends CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0, 1)

#parameters/Idle/blend_position

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var nav: NavigationAgent2D = $NavigationAgent2D

func _ready():
	GameManager.add_enemy(self)
	update_animation_parameters(starting_direction)

	# Make sure to not await during _ready.
	call_deferred("actor_setup")
	

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	## Now that the navigation map is no longer empty, set the movement target.
	#set_movement_target(movement_target_position)
	

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(_delta):
	#var space_state = get_world_2d().direct_space_state
	#print(GameManager.instance.players)
	var player = GameManager.players[0]
	if has_detected_player(player):
		navigate_to_location(player.position)
		if has_caught_player(player):
			die()
	else:
		navigate_to_location(Vector2(0.0, 0.0))
	
	move_and_slide()
	pick_new_state()
	
func die():
	GameManager.players.clear()
	GameManager.enemies.clear()
	get_tree().change_scene_to_file("res://UI/game_over.tscn")
	
func has_caught_player(player):
	var current_agent_position = global_position
	var player_distance_vector = player.position - current_agent_position
	
	if (player_distance_vector.length() < 20):
		return true
	return false
	
func has_detected_player(player):
	var current_agent_position = global_position
	var player_distance_vector = player.position - current_agent_position
	
	if (player_distance_vector.length() < 100):
		return true
	return false
		

	
func navigate_to_location(destination: Vector2):
	var current_agent_position: Vector2 = global_position
	set_movement_target(destination)
	if navigation_agent.is_navigation_finished():
		# Reached cat, game over!
		return

	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	velocity = current_agent_position.direction_to(next_path_position) * move_speed
	update_animation_parameters(velocity.normalized())
	
func update_animation_parameters(move_input : Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Idle/blend_position", move_input)
		animation_tree.set("parameters/Walk/blend_position", move_input)
		
func pick_new_state():
	#if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	#else: 
		#state_machine.travel("Idle")
		
	
	

 
 
