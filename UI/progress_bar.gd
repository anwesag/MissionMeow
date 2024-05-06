extends ProgressBar

var health = 0 : set = _set_health
var max_health = 100 
var min_health = 0

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	health = max(min_health, health)
	value = health 

	
func init_health(_health):
	health = _health
	value = health
	

