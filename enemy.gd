extends CharacterBody2D

class_name Enemy
@export var SPEED = 75.0
@onready var Map = $"/root/Map"
@onready var Player = $"/root/Player"
@onready var CooldownTimer = $CooldownTimer

var current_path : Array[Vector2i]
var frame_count = 0
var color : Color

var anim_sprite

func _draw() -> void:
	var drawable_path : Array[Vector2]
	if(current_path.size() > 1):
		for p in current_path:
			drawable_path.push_back(Map.map_to_global(Vector2(p) + Vector2(.5, .5)) - position)
		draw_polyline(drawable_path, color)

func recalculate_path():
	pass
	
func _physics_process(_delta: float) -> void:
	frame_count+=1
	if((frame_count % 5) == 0): 
		recalculate_path()
	queue_redraw()
	
	var direction
	if(!CooldownTimer.is_stopped() || !Player.has_control):
		anim_sprite.play("idle")
	else :
		if(current_path.size() <= 1):
			direction = (Player.position - position).normalized()
		else:
			direction = (Map.map_to_global(current_path[1]) - Map.map_to_global(current_path[0])).normalized()
		velocity = direction * SPEED
		move_and_slide()
		anim_sprite.play("walk")
		var collision = get_last_slide_collision()
		if(collision && collision.get_collider() && collision.get_collider().is_in_group("player")):
			collision.get_collider().get_pushed(direction)
			CooldownTimer.start()
