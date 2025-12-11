extends Node2D

@onready var HUD = $HUD
@onready var Map = $"/root/Map"
@onready var Player = $"Player"
@onready var BoidsManager = $"BoidsManager"

@onready var EnemyAStar = $"EnemyA*"
@onready var EnemyDijkstra = $"EnemyDijkstra"

@onready var Canvas = $CanvasModulate
@onready var BkgCanvas = $CanvasLayer/CanvasModulate
@onready var canvas_default_c = Canvas.color

func _ready():
	prep_game()

func darken():
	if($DarkenTimer.is_stopped()):
		$DarkenTimer.start()
		Canvas.color = Color()
		BkgCanvas.color = Color()
		Player.light.texture_scale *= 3./4.
		await  $DarkenTimer.timeout
		Canvas.color = canvas_default_c
		BkgCanvas.color = canvas_default_c
		Player.light.texture_scale /= 3./4.

func reset_enemy(e):
	e.position = Map.map_to_global(Map.get_random_spawn())
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
	# reset boids
	BoidsManager.reset_boids()
	
func start_game():
	Player.has_control = true

func game_over():
	if(not $DarkenTimer.is_stopped()):
		$DarkenTimer.stop()
		Canvas.color = canvas_default_c
		BkgCanvas.color = canvas_default_c
		Player.light.texture_scale *= 1.5
	#print("Game over !")
	HUD.game_over()
	await HUD.timer_over
	#print("Starting again !")
	prep_game()
	HUD.start()
	await HUD.timer_over
	#print("Start !")
	start_game()
