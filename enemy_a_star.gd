extends Enemy

func _ready() -> void:
	color = Color.AQUA
	anim_sprite = $AnimatedSprite2D

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
	current_path.push_front(start)

func recalculate_path(dest):
	var start = Map.global_to_map(position)
	var _destination = Map.global_to_map(dest)
	var open_list = {}
	var came_from = {}
	var gscore = {}
	var fscore = {}
	# 1 : add start to open list
	open_list[start] = 0
	gscore[start] = 0
	fscore[start] = start.distance_squared_to(_destination)
	# 2 : While we have cells to evaluate
	while !open_list.is_empty(): 
		var x = get_lowest_cost(open_list, fscore)
		# 2.1 : the cell is the end, reroute back
		if(x == _destination): 
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
				fscore[y] = y_cost + y.distance_squared_to(_destination)
				if(!open_list.has(y) && Map.is_cell_walkable(y)):
					open_list[y] = y_cost
	
