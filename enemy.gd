extends CharacterBody2D

class_name Enemy
@export var SPEED = 85.0
@export var VIEW_DIST = 150
@export var PATROL_DIST = 10
@onready var Map = $"/root/Map"
@onready var Player = $"/root/Main/Player"
@onready var CooldownTimer = $CooldownTimer

var current_path : Array[Vector2i]
var frame_count = 0
var color : Color

enum States {IDLE, CHASING, COOLDOWN, PATROL}
var current_state = States.IDLE

var anim_sprite

var direction
var destination
var last_collision = null


func _draw() -> void:
	var drawable_path : Array[Vector2]
	if(current_path.size() > 1):
		for p in current_path:
			drawable_path.push_back(Map.map_to_global(Vector2(p) + Vector2(.5, .5)) - position)
		draw_polyline(drawable_path, color)

func recalculate_path(_dest):
	pass
	
func update_direction():
	if(current_path.size() > 1):  
		direction = (Map.map_to_global(current_path[1]) - Map.map_to_global(current_path[0])).normalized()
	else:
		direction = (Player.position - position).normalized()
	
func update_states():
	var collision = last_collision
	if(!Player.has_control):
		current_state = States.IDLE
		velocity = Vector2(0,0)
	elif(CooldownTimer.is_stopped()):
		if(collision && collision.get_collider() && collision.get_collider().is_in_group("player")):
			var player_col = collision.get_collider()
			player_col.get_pushed((player_col.position - position).normalized())
			CooldownTimer.start()
			current_state = States.COOLDOWN
			velocity = Vector2(0,0)
		else: 
			var diff = (Player.position - position)
			if(diff.length() > VIEW_DIST):
				current_state = States.PATROL
			else:
				current_state = States.CHASING
		
func process_state():
	match current_state:
		States.COOLDOWN:
			anim_sprite.play("idle")
			last_collision = null
		States.IDLE:
			anim_sprite.play("idle")
			last_collision = null
		States.PATROL:
			anim_sprite.play("walk")
			if(destination == null || current_path.size() <= 1):
				var dest_range = 2 * PATROL_DIST * Map.tile_set.tile_size
				var rand_v = Vector2(randf() * dest_range.x, randf() * dest_range.y) - dest_range/2.0
				destination = position + rand_v
				recalculate_path(destination)
			elif((frame_count % 5) == 0): 
				recalculate_path(destination)
			update_direction()
			velocity = direction * SPEED
			anim_sprite.flip_h = (direction.x < 0)
			move_and_slide()
			last_collision = get_last_slide_collision()
		States.CHASING:
			anim_sprite.play("walk")
			if((frame_count % 5) == 0): 
				recalculate_path(Player.position)
			update_direction()
			velocity = direction * SPEED
			anim_sprite.flip_h = (direction.x < 0)
			move_and_slide()
			last_collision = get_last_slide_collision()
	
func _physics_process(_delta: float) -> void:
	frame_count+=1
	
	update_states()
	process_state()
	
	#move_and_slide()
	
	queue_redraw()
	
	#print(name + " : ", current_state, velocity)
	
