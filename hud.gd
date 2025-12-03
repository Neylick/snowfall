extends CanvasLayer

signal timer_over

@onready var StartSprite = $Control/StartSprite
@onready var GameOverSprite = $Control/GameOverSprite
@onready var HUDTimer = $HUDTimer
	
func start():
	StartSprite.visible = true
	HUDTimer.start()
	await HUDTimer.timeout
	StartSprite.visible = false

func game_over():
	GameOverSprite.visible = true
	HUDTimer.start()
	await HUDTimer.timeout
	GameOverSprite.visible = false

func _on_hud_timer_timeout() -> void:
	timer_over.emit()
