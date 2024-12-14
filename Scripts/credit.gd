extends Control

# Define the signal
signal back_game
signal quit_game

func _ready() -> void:
	print("Credit _ready")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_back_pressed() -> void:
	print("credit_screen _on_back_pressed")
	emit_signal("back_game")

func _on_quit_pressed() -> void:
	print("credit_screen _on_quit_pressed")
	emit_signal("quit_game")
