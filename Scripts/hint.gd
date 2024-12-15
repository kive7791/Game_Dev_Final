extends Control

# Define the signal
signal back_game
signal hint_1_game
signal hint_2_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("hint_screen _ready")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_back_pressed() -> void:
	print("hint_screen _on_back_pressed")
	emit_signal("back_game")

func _on_hint_1_pressed() -> void:
	print("hint_screen _on_hint_1_pressed")
	emit_signal("hint_1_game")

func _on_hint_2_pressed() -> void:
	print("hint_screen _on_hint_2_pressed")
	emit_signal("hint_2_game")
