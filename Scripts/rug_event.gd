extends Area2D

signal rug_event

func _ready() -> void:
	# Connect the input_event signal to handle mouse clicks
	connect("input_event", Callable(self, "_on_input_event"))

func _on_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("ui_left_mouseclick"):
		print("Left mouse button clicked on the rug area!")
		emit_signal("rug_event")
