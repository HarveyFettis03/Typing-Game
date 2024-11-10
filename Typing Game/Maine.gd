extends Node2D

var active_enemy = null 
var current_letter_index = -1
var difficulty: int = 0
var enemies_killed: int = 0

var Enemy =preload("res://Enemy.tscn")

onready var enemy_Container = $EnemyContainer
onready var spawn_container = $EnemySpawn
onready var spawn_timer = $SpawnTimer
onready var difficulty_value = $CanvasLayer/VBoxContainer/BotRow/HBoxContainer/DifficultyValue
onready var killed_value = $CanvasLayer/VBoxContainer/TopRow2/TopRow/KilledValue


func _ready() -> void:
	randomize()
	spawn_timer.start()
	spawn_enemy()




#finds the closest enemy to player if 2 start with the same letter
func find_new_enemy(typed_character: String):
	for enemy in enemy_Container.get_children():
		var prompt = enemy.get_prompt()
		var next_character = prompt.substr(0, 1)
		if next_character == typed_character:
			print("New enemy located that starts with %s" % next_character)
			active_enemy = enemy
			current_letter_index = 1
			active_enemy.set_next_char(current_letter_index)
			return

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		var typed_event = event as InputEventKey
		var key_typed = PoolByteArray([typed_event.unicode]).get_string_from_utf8()
		
		if active_enemy == null:
			find_new_enemy(key_typed)
		else:
			var prompt = active_enemy.get_prompt()
			var next_character = prompt.substr(current_letter_index, 1)
			if key_typed == next_character:
				print("Success typed %s" % key_typed)
				current_letter_index += 1
				active_enemy.set_next_char(current_letter_index)
				if current_letter_index == prompt.length():
					print("Done")
					current_letter_index = -1
					active_enemy.queue_free()
					active_enemy = null
					enemies_killed += 1
					killed_value.text = str(enemies_killed)
			else:
				print("Failedtyped %s instead of %s" % [key_typed, next_character])




func _on_SpawnTimer_timeout():
	spawn_enemy()
	
	
func spawn_enemy():
	var enemy_instance = Enemy.instance()
	var spawns = spawn_container.get_children()
	var index = randi() % spawns.size()
	enemy_Container.add_child(enemy_instance)
	enemy_instance.global_position = spawns[index].global_position
	enemy_instance.set_difficulty(difficulty)


func _on_DifficultyTimer_timeout():
	difficulty += 1
	GlobalSignals.emit_signal("difficulty_increased", difficulty)
	print("Difficulty increased to %d" % difficulty)
	var new_wait_time = spawn_timer.wait_time - 0.2
	spawn_timer.wait_time = clamp(new_wait_time, 1, spawn_timer.wait_time)
	difficulty_value.text = str(difficulty)
	

