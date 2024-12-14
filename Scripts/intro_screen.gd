extends Control

# Define the signal
signal start_game
signal quit_game
signal credit_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("intro_screen _ready")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_start_pressed() -> void:
	print("intro_screen _on_start_pressed")
	emit_signal("start_game")

func _on_quit_pressed() -> void:
	print("intro_screen _on_quit_pressed")
	emit_signal("quit_game")

func _on_credits_pressed() -> void:
	print("intro_screen _on_credits_pressed")
	emit_signal("credit_game")
