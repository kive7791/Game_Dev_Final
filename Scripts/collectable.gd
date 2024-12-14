extends Area2D

signal crystal_collected(body) # signal - crystal colleced for game

func _ready() -> void:
	add_to_group("Collectible")

func _on_body_entered(body: Node2D) -> void:
	print("crstyal _on_body_entered")
	if body.is_in_group("Player"):  # Ensure the body is the player
		emit_signal("crystal_collected", body)  # Call a method on the player to collect item
		queue_free()  # Remove the ammo pickup from the scene
