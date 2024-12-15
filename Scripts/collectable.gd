extends Area2D

signal crystal_collected(body) # signal - crystal colleced for game

func _ready() -> void:
	add_to_group("Collectible")

func _on_body_entered(body: Node2D) -> void:
	print("crstyal _on_body_entered ", body.name)
	if body.is_in_group("Player"):  # Ensure the body is the player
		if body.has_method("add_to_inventory"):  # Check if the method exists
			body.add_to_inventory(self)  # Directly call the method on the Player
		else:
			print("Warning: Player does not have 'add_to_inventory' method!")
		#emit_signal("crystal_collected", self)  # Call a method on the player to collect item
		queue_free()  # Remove the ammo pickup from the scene
