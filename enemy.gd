extends CharacterBody2D

class_name Enemy
@onready var Map = $"/root/Map"

var current_path : Array[Vector2i]
var frame_count = 0
	
func _draw() -> void:
	var start = position
	var destination = $"/root/Player".position
	draw_line(start - position, destination - position, Color.RED)
	
	var drawable_path : Array[Vector2]
	for p in current_path:
		drawable_path.push_back(Map.map_to_global(Vector2(p) + Vector2(.5, .5)) - position)
	draw_polyline(drawable_path, Color.AQUA)
