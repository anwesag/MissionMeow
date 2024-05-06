extends CharacterBody2D

@export var move_speed : float = 150
@export var starting_direction : Vector2 = Vector2(0, 1)
#parameters/Idle/blend_position

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var health_bar = $CanvasLayer/ProgressBar
@onready var timer = $CanvasLayer2/Label
@onready var health = 100
@onready var time = 0
@onready var minutes = "0"
@onready var seconds = "0"
@onready var last_updated_time = 0

func _ready():
	health_bar.init_health(health)
	GameManager.add_player(self)
	update_animation_parameters(starting_direction)

func _physics_process(_delta):
	time += _delta
	minutes = str(int(time)/60) 
	seconds = "0" + str(int(time) % 60) if (int(time) % 60 < 10) else str(int(time) % 60)
	if int(time) - last_updated_time == 5:
		update_health(-1)
		last_updated_time = int(time)
		
	timer.text = minutes + ":" + seconds
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	update_animation_parameters(input_direction)
	
	velocity = input_direction * move_speed
	
	move_and_slide()
	pick_new_state()
	
	
func update_health(change_val):
	health += change_val
	health_bar._set_health(health)
	if health <= 0:
		die()
	print(health)
	
func die():
	GameManager.players.clear()
	GameManager.enemies.clear()
	get_tree().change_scene_to_file("res://UI/game_over.tscn")
	
func update_animation_parameters(move_input : Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Idle/blend_position", move_input)
		animation_tree.set("parameters/Walk/blend_position", move_input)
		
func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else: 
		state_machine.travel("Idle")
		
	
	

 
 
