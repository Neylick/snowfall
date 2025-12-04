extends Node2D

@onready var HUD = $HUD
@onready var Map = $"/root/Map"
@onready var Player = $"/root/Main/Player"

@onready var EnemyAStar = $"EnemyA*"
@onready var EnemyDijkstra = $"EnemyDijkstra"

func get_random_spawn() -> Vector2:
	var res = Vector2i(0,0)
	while res.distance_squared_to(Vector2i(0,0)) <= 3 || !Map.is_cell_walkable(res):
		res = Vector2i(randf() * Map.SIZE, randf() * Map.SIZE) 
	return res

func reset_enemy(e):
	e.position = Map.map_to_global(get_random_spawn())
	e.current_path.clear()
	e.frame_count = 0
	e.direction = Vector2()
	e.destination = Vector2()
	e.last_collision = null

func prep_game():
	# reset player
	Player.position = Vector2(0,0)
	Player.anim_sprite.rotation = 0
	Player.anim_sprite.scale = Vector2(1,1)
	# reset map
	Map.init_map()
	# reset enemies
	reset_enemy(EnemyAStar)
	reset_enemy(EnemyDijkstra)
	
func start_game():
	Player.has_control = true

func game_over():
	print("Game over !")
	HUD.game_over()
	await HUD.timer_over
	print("Starting again !")
	prep_game()
	HUD.start()
	await HUD.timer_over
	print("Start !")
	start_game()
