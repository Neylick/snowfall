extends CharacterBody2D

@export var SPEED = 100.0

var push_dir = Vector2(0,0)
var was_pushed = false
@export var PUSH_STRENGH = 700.0
@onready var anim_sprite = $CollisionShape2D/AnimatedSprite2D

signal on_game_over

var has_control = true

func get_pushed(dir):
	was_pushed = true
	push_dir = dir
	#print("got pushed")

func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	if has_control:
		if direction:
			direction = direction.normalized()
			velocity = direction * SPEED
			anim_sprite.play("walk")
			anim_sprite.flip_h = velocity.x < 0
		else:
			velocity = Vector2(move_toward(velocity.x, 0, SPEED), move_toward(velocity.y, 0, SPEED))
			anim_sprite.play("idle")
		if(was_pushed):
			was_pushed = false
			velocity = push_dir * PUSH_STRENGH
		
		move_and_slide()
		var collision = get_last_slide_collision()
		if(collision):
			var collider = collision.get_collider()
			if(collider && (collider.is_in_group("water"))):
				anim_sprite.play("idle")
				has_control = false
				var tween = create_tween().set_parallel()
				tween.tween_callback(func(): on_game_over.emit())
				tween.tween_property(anim_sprite, "rotation", TAU, 1).as_relative()
				tween.tween_property(anim_sprite, "scale", Vector2(0,0), 1)
		

	
