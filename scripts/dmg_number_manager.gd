extends Node

@onready var dmg_number_scene = preload("res://scenes/damage_numbers.tscn")

func display_number(value: int, pos: Vector2, is_crit: bool = false):
	var n = dmg_number_scene.instantiate()
	n.global_position = pos
	
	get_tree().root.add_child(n)
	n.set_text(str(value))
