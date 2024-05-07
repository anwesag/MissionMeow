extends CharacterBody2D

@export var move_speed : float = 125
@export var starting_direction : Vector2 = Vector2(0, 1)
#parameters/Idle/blend_position

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var main = get_tree().get_root()
@onready var poop = load("res://UI/poop_sprite.tscn")
@onready var health_bar = $CanvasLayer/ProgressBar
@onready var timer = $CanvasLayer2/Label
@onready var health = 100
@onready var time = 0
@onready var minutes = "0"
@onready var seconds = "0"
@onready var last_updated_time = 0
@onready var last_poop_time = 0
@onready var milk_location = Vector2(425.0, 80.0)
@onready var health_drop_rate = -10

func _ready():
	health_bar.init_health(health)
	GameManager.add_player(self)
	update_animation_parameters(starting_direction)
	
func trigger_poop():
	if int(time) - last_poop_time >= 10:
		last_poop_time = int(time)		
		var instance = poop.instantiate()
		instance.zdex = z_index - 1
		instance.spawn_pos = global_position
		main.add_child.call_deferred(instance)
	
func _input(event):
	if event.is_action_pressed("poop"):
		trigger_poop()
	if event.is_action_pressed("meow"):
		$SoundMeow.play()

func _physics_process(_delta):
	time += _delta
	minutes = str(int(time)/60) 
	seconds = "0" + str(int(time) % 60) if (int(time) % 60 < 10) else str(int(time) % 60)
	if int(time) - last_updated_time == 5:
		update_health(health_drop_rate)
		last_updated_time = int(time)
	timer.text = minutes + ":" + seconds
	
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	update_animation_parameters(input_direction)
	
	velocity = input_direction * move_speed
	
	if (milk_location - global_position).length() < 20:
		die()
		get_tree().change_scene_to_file("res://UI/mission_success.tscn")
		
	
	move_and_slide()
	pick_new_state()
	
	
func update_health(change_val):
	health += change_val
	health = max(health, 0)
	health = min(health, 100)
	health_bar._set_health(health)
	if health <= 0:
		die()
		get_tree().change_scene_to_file("res://UI/game_over.tscn")
		
	print(health)
	
func die():
	GameManager.players.clear()
	GameManager.enemies.clear()
	for i in range(2, main.get_child_count()):
		main.get_child(i).queue_free()
		
func update_animation_parameters(move_input : Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Idle/blend_position", move_input)
		animation_tree.set("parameters/Walk/blend_position", move_input)
		
func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else: 
		state_machine.travel("Idle")
		
	
	

 
 
