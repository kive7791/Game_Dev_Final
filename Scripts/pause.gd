extends Control

# Define the signal
signal restart_game
signal quit_game
signal back_game
signal hint_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("pause_screen _ready")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_restart_pressed() -> void:
	print("pause_screen restart_pressed")
	emit_signal("restart_game")

func _on_quit_pressed() -> void:
	print("pause_screen _on_quit_pressed")
	emit_signal("quit_game")

func _on_back_pressed() -> void:
	print("pause_screen _on_back_pressed")
	emit_signal("back_game")

func _on_hint_pressed() -> void:
	print("pause_screen _on_hint_pressed")
	emit_signal("hint_game")
