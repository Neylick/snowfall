extends Area2D

@onready var Player = $"/root/Main/Player"
@onready var Main = $"/root/Main"
@onready var anim_sprite = $AnimatedSprite2D

@export var max_velocity = 1.2
@export var min_dist = 20.0
@export var max_dist = 40.0

@export var close_inhib = 100.0
@export var away_inhib = 10.0
@export var with_inhib = 40.0

@export var towards_str = 1.
@export var fear_str = 3

var close_boids = []
var velocity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#velocity = Vector2(randf(), randf())
	velocity = (Player.position - position).normalized()
	
func _draw() -> void:
	#draw_line(Vector2(0,0), velocity * 10.0, Color.RED)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	moveTowardsPlayer(towards_str)
	moveAwayEnemies(max_dist, fear_str)
	
	moveAway(min_dist, away_inhib)
	moveCloser(close_inhib)
	moveWith(with_inhib)
	
	if(velocity.length() > max_velocity): 
		velocity = velocity.normalized() * max_velocity
	
	position += velocity
	
	anim_sprite.flip_h = (velocity.x > 0)
	
	queue_redraw()

func _on_detect_other_area_entered(area: Area2D) -> void:
	if(area.is_in_group("boids")):
		close_boids.append(area)
		#print("ADDED BOID")

func _on_detect_other_area_exited(area: Area2D) -> void:
	if(area.is_in_group("boids")):
		close_boids.erase(area)
		#print("RM BOID")

# set our velocity towards the others
func moveCloser(strength):
	if len(close_boids) < 1: return
	# calculate the average distances from the other boids
	var avg = Vector2(0,0)
	for boid in close_boids :
		if((position - boid.position).length() > min_dist):
			avg += position - boid.position
	avg /= len(close_boids)
	velocity -= avg/strength

# set our velocity along the others
func moveWith(strength):
	if len (close_boids) < 1: return
	# calculate the average velocities of the other boids
	var avg = Vector2(0,0)
	for boid in close_boids :
		avg += boid.velocity
	avg /= len(close_boids)
	velocity += (avg/strength)
	
# move away if close enough
func moveAway(minDistance, strength):
	if len ( close_boids ) < 1: return
	var distance = Vector2(0, 0)
	var numClose = 0
	for boid in close_boids :
		var d = position.distance_to(boid.position)
		if d < minDistance :
			numClose += 1
			var diff = (position - boid.position)
			if diff.x >= 0: diff.x = sqrt( minDistance ) - diff.x
			else: diff.x = -sqrt( minDistance ) - diff.x
			if diff.y >= 0: diff.y = sqrt( minDistance ) - diff.y
			else: diff.y = -sqrt( minDistance ) - diff.y
			distance += diff
	if numClose == 0:
		return
	velocity -= distance / strength

# set our velocity towards a target (player)
func moveTowardsPlayer(strength):
	var diff = Player.position - position
	var dist = diff.length()
	if(dist > 2):
		velocity += strength * diff / dist;

# set our velocity away from enemies
func moveAwayEnemies(maxDist, strength):
	var diffA = Main.EnemyAStar.position - position
	var lA = diffA.length()
	if(lA <= maxDist):
		velocity -= strength * diffA / lA
	var diffB = Main.EnemyDijkstra.position - position
	var lB = diffB.length()
	if(lB <= maxDist):
		velocity -= strength * diffB / lB

func _on_player_enter(_body: Node2D) -> void:
	Main.darken()
