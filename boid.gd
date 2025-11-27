extends Area2D

@export var close_str = 100
@export var with_str = 40
@export var min_dist = 20
@export var away_str = 5

var close_boids
var velocity = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	moveCloser(close_str)
	moveWith(with_str)
	moveAway(min_dist, away_str)

func _on_area_entered(area: Area2D) -> void:
	if(area.is_in_group("boids")):
		close_boids.append(area.get_parent())

func _on_area_exited(area: Area2D) -> void:
	if(area.is_in_group("boids")):
		close_boids.erase(area.get_parent())

func moveCloser(strength):
	if len(close_boids) < 1: return
	# calculate the average distances from the other boids
	var avg = Vector2(0,0)
	for boid in close_boids :
		avg += position - boid.position
	avg /= len(close_boids)
	# set our velocity towards the others
	velocity -= avg/strength

func moveWith(strength):
	if len (close_boids) < 1: return
	# calculate the average velocities of the other boids
	var avg = Vector2(0,0)
	for boid in close_boids :
		avg += boid.velocity
	avg /= len(close_boids)
	# set our velocity towards the others
	velocity += (avg/strength)
	
func moveAway(minDistance, strength):
	if len ( close_boids ) < 1: return
	var distance = Vector2(0, 0)
	var numClose = 0
	for boid in close_boids :
		distance = position.distance_to(boid.position)
		if distance < minDistance :
			numClose += 1
			var diff = (position.x - boid.position.x)
			if diff.x >= 0: diff.x = sqrt( minDistance ) - diff.x
			else: diff.x = -sqrt( minDistance ) - diff.x
			if diff.y >= 0: diff.y = sqrt( minDistance ) - diff.y
			else: diff.y = -sqrt( minDistance ) - diff.y
			distance += diff
	if numClose == 0:
		return
	velocity -= distance / strength
