extends TileMapLayer

@export var SIZE = 50
@onready var center = Vector2(SIZE/2.0, SIZE/2.0)
@onready var WaterMap = $WaterLayer
var frame_count = 0

func is_cell_erased(coord : Vector2i):
	return get_cell_source_id(coord) == -1 || get_cell_tile_data(coord) == null

func global_to_map(coord : Vector2) -> Vector2i :
	return Vector2i(coord + center * Vector2(tile_set.tile_size)) / tile_set.tile_size

func map_to_global(coord : Vector2) -> Vector2 :
	return (coord - center) * Vector2(tile_set.tile_size)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position -= center * Vector2(tile_set.tile_size)
	var cell_arr : Array[Vector2i]
	for i in SIZE:
		for j in SIZE:
			var point = Vector2(i, j)
			if(point.distance_to(center) <= SIZE/2.0):
				cell_arr.append(Vector2i(point))
			else:
				WaterMap.set_cell(point, 0, Vector2(0,0))
	set_cells_terrain_connect(cell_arr, 0, 0, false)
	
func remove_terrain(coords : Vector2i):
	erase_cell(coords)
	WaterMap.set_cell(coords, 0, Vector2(0,0))
	#var neighboors = get_surrounding_cells(coords)
	#set_cells_terrain_connect(neighboors, 0, -1, false)

func _process(_delta: float) -> void:
	frame_count+=1
	if((frame_count % 20) == 0):
		print("Eroding terrain")
		var rand_cell = Vector2i(int(randf()*SIZE), int(randf()*SIZE))
		remove_terrain(rand_cell)
		
