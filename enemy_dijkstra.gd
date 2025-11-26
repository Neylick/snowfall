extends CharacterBody2D

const SPEED = 1.0
@onready var anim_sprite = $CollisionShape2D/AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	var direction = ($"/root/Player".position - position)
	var distance_to_player =  direction.length()
	if direction:
		velocity = (direction / distance_to_player) * SPEED
		anim_sprite.play("walk")
		anim_sprite.flip_h = velocity.x < 0
	else:
		anim_sprite.play("idle")

	var collision = move_and_collide(velocity)
	if collision and collision.get_collider() and collision.get_collider().is_in_group("player"):
		collision.get_collider().get_pushed(direction)
		#print("pushed player")
