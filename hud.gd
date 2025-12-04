extends CanvasLayer

signal timer_over

@onready var StartSprite = $Control/StartSprite
@onready var GameOverSprite = $Control/GameOverSprite
@onready var HUDTimer = $HUDTimer

var timer = 0
var pause_timer = false
	
func start():
	StartSprite.visible = true
	timer = 0
	HUDTimer.start()
	await HUDTimer.timeout
	StartSprite.visible = false
	pause_timer = false

func game_over():
	GameOverSprite.visible = true
	HUDTimer.start()
	pause_timer = true
	await HUDTimer.timeout
	GameOverSprite.visible = false

func _on_hud_timer_timeout() -> void:
	timer_over.emit()
	
func _process(delta: float) -> void:
	if(!pause_timer):
		timer += delta
		$TimerText.text = "%02d:%02d.%02d" % [int(timer/60), int(timer), int(timer*100)%100]
