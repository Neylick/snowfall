extends Node2D

@export var boid_scene : PackedScene
@export var boids_count : int = 8

@onready var Map = $"/root/Map"

func spawn_boids():
	for b in range(boids_count):
		var v = Map.map_to_global(Map.get_random_spawn())
		var boid_inst = boid_scene.instantiate()
		boid_inst.global_position = v
		add_child(boid_inst)
		
func clear_boids():
	for n in get_children():
		n.queue_free()
		
func reset_boids():
	clear_boids()
	spawn_boids()
