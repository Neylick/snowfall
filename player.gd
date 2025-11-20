extends CharacterBody2D

@export var SPEED = 100.0

var push_dir
var was_pushed
@export var PUSH_STRENGH = 100.0

func get_pushed(dir):
	was_pushed = true
	push_dir = dir
	print("got pushed")

func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	if direction:
		direction = direction.normalized()
		velocity = direction * SPEED
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		velocity = Vector2(move_toward(velocity.x, 0, SPEED), move_toward(velocity.y, 0, SPEED))
		$AnimatedSprite2D.play("idle")
		
	if(was_pushed):
		was_pushed = false
		velocity = push_dir * PUSH_STRENGH

	move_and_slide()
