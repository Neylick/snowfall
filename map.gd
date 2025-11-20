extends TileMapLayer

@export var INITIAL_SIZE = 50
var frame_count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var center = Vector2(INITIAL_SIZE/2.0, INITIAL_SIZE/2.0)
	var cell_arr : Array[Vector2i]
	for i in INITIAL_SIZE:
		for j in INITIAL_SIZE:
			var point = Vector2(i, j)
			if(point.distance_to(center) <= INITIAL_SIZE/2.0):
				#set_cell(Vector2i(point), 0, Vector2(0,0))
				cell_arr.append(Vector2i(point))
	set_cells_terrain_connect(cell_arr, 0, 0, false)


func _process(_delta: float) -> void:
	frame_count+=1
	if(frame_count % 3000):
		var rand_cell = Vector2i(int(randf()*INITIAL_SIZE), int(randf()*INITIAL_SIZE))
		var neighboors = get_surrounding_cells(rand_cell)
		erase_cell(rand_cell)
		set_cells_terrain_connect(neighboors, 0, -1, true)
