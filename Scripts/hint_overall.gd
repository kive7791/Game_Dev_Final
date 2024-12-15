extends Node2D

# Define the signal
signal back_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("pause_screen _ready")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_back_pressed() -> void:
	print("pause_screen _on_back_pressed")
	emit_signal("back_game")
