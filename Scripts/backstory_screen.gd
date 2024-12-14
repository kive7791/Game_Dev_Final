extends Control

# Define the signal
signal start_game
signal back_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("backstory_screen _ready")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_start_pressed() -> void:
	print("backstory_screen _on_start_pressed")
	emit_signal("start_game")

func _on_back_pressed() -> void:
	print("backstory_screen _on_back_pressed")
	emit_signal("back_game")

# Goes off in 50s because reading time is around there, and 889 * 0.05 = 45: character amout * character per sec = time on screen
func _on_timer_timeout() -> void:
	print("backstory_screen _Timeout")
	emit_signal("start_game")
