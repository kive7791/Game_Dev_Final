extends Area2D

signal key_collected(body) # signal - crystal colleced for game

func _ready() -> void:
	add_to_group("Collectible")

func _on_body_entered(body: Node2D) -> void:
	print("key _on_body_entered ", body.name)
	if body.is_in_group("Player"):  # Ensure the body is the player
		if body.has_method("add_to_inventory"):  # Check if the method exists
			body.add_to_inventory(self)  # Directly call the method on the Player
		else:
			print("Warning: Player does not have 'add_to_inventory' method!")
		queue_free()  # Remove the ammo pickup from the scene
