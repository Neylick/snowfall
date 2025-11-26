extends CharacterBody2D

const SPEED = 1.0
@onready var anim_sprite = $CollisionShape2D/AnimatedSprite2D
@onready var Map = $"/root/Map"

var current_path : Array[Vector2i]
	
func get_lowest_cost(open_list : Dictionary, fscore : Dictionary):
	var min_v = 1e30
	var min_key = Vector2i(-1e30, -1e30)
	for k in open_list:
		if(fscore[k] < min_v):
			min_v = fscore[k]
			min_key = k
	return min_key
	
func reroute(node_coord, start, closed_list):
	current_path.clear()
	while node_coord != start:
		current_path.push_front(node_coord)
		node_coord = closed_list[node_coord]

func recalculate_path():
	var start = Map.global_to_map(position)
	var destination = Map.global_to_map($"/root/Player".position)
	var open_list = {}
	var came_from = {}
	var gscore = {}
	var fscore = {}
	# 1 : add start to open list
	open_list[start] = 0
	gscore[start] = 0
	fscore[start] = start.distance_squared_to(destination)
	# 2 : While we have cells to evaluate
	while !open_list.is_empty(): 
		var x = get_lowest_cost(open_list, fscore)
		# 2.1 : the cell is the end, reroute back
		if(x == destination): 
			reroute(x, start, came_from)
			
		# 2.2 we checked this node 
		var x_cost = open_list[x]
		open_list.erase(x)
		
		# 2.3 : open each neighboor if valid, add to open list
		var neighboors = Map.get_surrounding_cells(x)
		for y in neighboors: 
			var y_cost = x_cost + 1
			if(!gscore.has(y) || y_cost < gscore[y]):
				came_from[y] = x
				gscore[y] = y_cost
				fscore[y] = y_cost + y.distance_squared_to(destination)
				if(!open_list.has(y) && !Map.is_cell_erased(y)):
					open_list[y] = y_cost

func _physics_process(_delta: float) -> void:
	#var direction = ($"/root/Player".position - position)
	#var distance_to_player =  direction.length()
	#if direction:
		#velocity = (direction / distance_to_player) * SPEED
		#anim_sprite.play("walk")
		#anim_sprite.flip_h = velocity.x < 0
	#else:
		#anim_sprite.play("idle")
#
	#var collision = move_and_collide(velocity)
	#if collision and collision.get_collider() and collision.get_collider().is_in_group("player"):
		#collision.get_collider().get_pushed(direction)
		
	recalculate_path()
	queue_redraw()
	
func _draw() -> void:
	var start = position
	var destination = $"/root/Player".position
	draw_line(start - position, destination - position, Color.RED)
	
	var drawable_path : Array[Vector2]
	for p in current_path:
		drawable_path.push_back(Vector2(Map.map_to_global(p)) - position)
	draw_polyline(drawable_path, Color.AQUA)
	
