extends Control

signal item_selected(item_name)

@export var selected_index = 0
var inventory_items: Array = []  # Stores references to HBoxContainers for each item

func _ready() -> void:
	print("[inventory.gd:3] _ready() called")

func add_item(item_name: String, item_sprite: Texture, category: String = "default"):
	print("[inventory.gd:9] add_item() called with item_name: ", item_name, " sprite: ", item_sprite.get_class(), " category: ", category)
	# Create an HBoxContainer for the item
	var item_hbox = HBoxContainer.new()
	item_hbox.name = item_name
	item_hbox.set_meta("category", category)  # Store item's category as metadata

	# Add the item's TextureRect for its sprite
	var item_image = TextureRect.new()
	var region = Rect2(Vector2(0, 0), Vector2(64, 32))
	item_image.texture = convert_to_atlas_texture(item_sprite, region)
	#item_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED  # Ensure aspect ratio is preserved
	#item_image.scale = Vector2(0.25, 0.25)  # Set icon size
	item_hbox.add_child(item_image)

	# Add the item's Label for its name
	var item_label = Label.new()
	item_label.text = item_name
	item_hbox.add_child(item_label)

	# Add the HBoxContainer to VBoxContainer
	$ScrollContainer/VBoxContainer.add_child(item_hbox)
	inventory_items.append(item_hbox)

	# Connect the HBoxContainer's input event with binding
	item_hbox.connect(
		"gui_input",
		Callable(self, "_on_item_clicked").bind(item_name)
	)

func convert_to_atlas_texture(compressed_texture: Texture, region: Rect2) -> AtlasTexture:
	# Create an AtlasTexture
	var atlas_texture = AtlasTexture.new()
	atlas_texture.atlas = compressed_texture
	atlas_texture.region = region  # Set the region in the source texture
	
	return atlas_texture

func _on_item_clicked(event: InputEvent, item_name: String):
	#print("[inventory.gd:30] _on_item_clicked() called with item_name: ", item_name)
	if event is InputEventMouseButton and event.pressed:
		print("Item clicked:", item_name)

		# Find the index of the clicked item in the inventory
		for i in range(len(inventory_items)):
			if inventory_items[i].name == item_name:
				selected_index = i
				break

		highlight_item()
		emit_signal("item_selected", item_name)

func item_index(item_name: String) -> int:
	#print("[inventory.gd:44] item_index() called")
	var count: int = 1
	for item in inventory_items:
		#print("inventory item ", item)
		if item.name == item_name:
			#print("inventory item ", item.name)
			break
		count += 1
	#print("inventory ", count)
	return count

func highlight_item():
	print("[inventory.gd:42] highlight_item() called")
	# Reset highlights for all items
	for item in inventory_items:
		for child in item.get_children():
			if child is TextureRect:
				print("player: child ", child.name)
				child.modulate = Color(1, 1, 1, 1)  # Default color

	# Highlight the selected item
	if inventory_items.size() > selected_index:
		print("player: select child ", inventory_items[selected_index].name)
		inventory_items[selected_index].modulate = Color(0.8, 0.8, 1)  # Highlight color
