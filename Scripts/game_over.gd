extends Control

# Node references
@onready var title = %Win_Lose

# Define the signal
signal restart_game
signal quit_game
signal credit_game

func _ready() -> void:
	print("game_over _ready")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_message(message: String) -> void:
	title.text = message
	title.modulate = Color.DARK_GREEN
	if not message.contains("WIN"):
		title.modulate = Color.DARK_RED

func _on_restart_pressed() -> void:
	print("game_over restart_pressed...")
	emit_signal("restart_game")

func _on_quit_pressed() -> void:
	print("game_over _on_quit_pressed")
	emit_signal("quit_game")

func _on_credits_pressed() -> void:
	print("game_over _on_credits_pressed")
	emit_signal("credit_game")
