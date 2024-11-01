extends Node2D

var active_enemy = null 
var current_letter_index = -1


onready var enemy_Container = $EnemyContainer
#finds the closest enemy to player if 2 start with the same letter
func find_new_enemy(typed_character: String):
	for enemy in enemy_Container.get_children():
		var prompt = enemy.get_prompt()
		var next_character = prompt.substr(0, 1)
		if next_character == typed_character:
			print("New enemy located that starts with %s" % next_character)
			active_enemy = enemy
			current_letter_index = -1

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
				if current_letter_index == prompt.length():
					print("Done")
					current_letter_index = -1
					active_enemy.queue_free()
					active_enemy = null
			else:
				print("Failedtyped %s instead of %s" % [key_typed, next_character])
