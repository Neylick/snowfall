extends TileMapLayer

@export var SIZE = 50
@export var MIN_DIST_TO_PLAYER = 2
@onready var center = Vector2(SIZE/2.0, SIZE/2.0)
@onready var WaterMap = $WaterLayer
@onready var ObstacleMap = $ObstaclesLayer
@onready var Player = $"/root/Main/Player"

var frame_count = 0
var eroding = false

func is_cell_walkable(coord : Vector2i):
	return !(get_cell_source_id(coord) == -1 || get_cell_tile_data(coord) == null || (ObstacleMap.get_cell_source_id(coord) != -1 && ObstacleMap.get_cell_tile_data(coord) != null))

func global_to_map(coord : Vector2) -> Vector2i :
	return Vector2i(coord + center * Vector2(tile_set.tile_size)) / tile_set.tile_size

func map_to_global(coord : Vector2) -> Vector2 :
	return (coord - center) * Vector2(tile_set.tile_size)
	
func set_water(coords : Vector2i) :
	erase_cell(coords)
	ObstacleMap.erase_cell(coords)
	WaterMap.set_cell(coords, 2, Vector2(0,0))

func init_map():
	var cell_arr : Array[Vector2i]
	for i in SIZE + 1:
		for j in SIZE + 1:
			var point = Vector2(i, j)
			if(point.distance_to(center) > SIZE/2.0):
				set_water(point)
			else:
				cell_arr.append(Vector2i(point))
				WaterMap.erase_cell(point)
				if(randf() > .1):
					ObstacleMap.erase_cell(point)
				else:
					var source_id = ObstacleMap.tile_set.get_source_id(0)
					var source = ObstacleMap.tile_set.get_source(source_id)
					var rand_index = int(randf() * source.get_tiles_count())
					var random_id = source.get_tile_id(rand_index)
					ObstacleMap.set_cell(point, source_id, random_id)
	set_cells_terrain_connect(cell_arr, 0, 0, false)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position -= center * Vector2(tile_set.tile_size)
	init_map()
	eroding = true
	
func start():
	init_map()
	eroding = true
	
func remove_terrain(coords : Vector2i):
	var player_map_pos = global_to_map(Player.position)
	if(player_map_pos.distance_squared_to(coords) > MIN_DIST_TO_PLAYER*MIN_DIST_TO_PLAYER):
		set_water(coords)

func _process(_delta: float) -> void:
	frame_count+=1
	if(eroding && (frame_count % 20) == 0):
		var rand_cell = Vector2i(int(randf()*SIZE), int(randf()*SIZE))
		remove_terrain(rand_cell)
		
