extends CharacterBody2D

const SPEED = 75.0

func _physics_process(_delta: float) -> void:
	var direction = ($"/root/Player".position - position)
	var distance_to_player =  direction.length()
	if direction:
		velocity = (direction / distance_to_player) * SPEED
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.play("idle")

	var collision = move_and_collide(velocity)
	if collision and collision.get_collider() and collision.get_collider().is_in_group("player"):
			collision.get_collider().get_pushed(direction)
			print("pushed player")
