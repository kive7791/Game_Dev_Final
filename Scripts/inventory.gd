extends Control

signal item_selected(item_name)

@export var selected_index = 0
var inventory_items: Array = []  # Stores references to HBoxContainers for each item

@export var sorting_enabled: bool = false  # Enable/Disable sorting
@export var filtering_enabled: bool = false  # Enable/Disable filtering
var filtered_category: String = ""  # Current filter category (if any)

func _ready() -> void:
	print("[inventory.gd:3] _ready() called")
	# Connect navigation buttons
	$PreviousButton.connect("pressed", Callable(self, "_on_previous_button_pressed"))
	$NextButton.connect("pressed", Callable(self, "_on_next_button_pressed"))

func add_item(item_name: String, item_sprite: Texture, category: String = "default"):
	print("[inventory.gd:9] add_item() called with item_name: ", item_name, " sprite: ", item_sprite.get_class(), " category: ", category)
	# Create an HBoxContainer for the item
	var item_hbox = HBoxContainer.new()
	item_hbox.name = item_name
	item_hbox.set_meta("category", category)  # Store item's category as metadata

	# Add the item's TextureRect for its sprite
	var item_image = TextureRect.new()
	item_image.texture = item_sprite
	item_image.size = Vector2(0.5, 0.5)  # Set icon size
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

	# Sort and filter items
	if sorting_enabled:
		sort_inventory()
	if filtering_enabled:
		apply_filter()

func _on_item_clicked(event: InputEvent, item_name: String):
	print("[inventory.gd:30] _on_item_clicked() called with item_name: ", item_name)
	if event is InputEventMouseButton and event.pressed:
		print("Item clicked:", item_name)

		# Find the index of the clicked item in the inventory
		for i in range(len(inventory_items)):
			if inventory_items[i].name == item_name:
				selected_index = i
				break

		highlight_item()
		emit_signal("item_selected", item_name)

func highlight_item():
	print("[inventory.gd:42] highlight_item() called")
	# Reset highlights for all items
	for item in inventory_items:
		for child in item.get_children():
			print("player: child ", child.name)
			if child.name == "TextureRect":
				child.modulate = Color(1, 1, 1)  # Default color

	# Highlight the selected item
	if inventory_items.size() > selected_index:
		inventory_items[selected_index].modulate = Color(0.8, 0.8, 1)  # Highlight color

func _on_previous_button_pressed():
	print("[inventory.gd:50] _on_previous_button_pressed() called")
	if selected_index > 0:
		selected_index -= 1
		highlight_item()

func _on_next_button_pressed():
	print("[inventory.gd:55] _on_next_button_pressed() called")
	if selected_index < inventory_items.size() - 1:
		selected_index += 1
		highlight_item()

func sort_inventory():
	print("[inventory.gd:60] sort_inventory() called")
	inventory_items.sort_custom(Callable(self, "sort_by_name"))
	for child in $ScrollContainer/VBoxContainer.get_children():
		$ScrollContainer/VBoxContainer.remove_child(child) 	# Remove all children
		child.queue_free()
	for item in inventory_items:
		$ScrollContainer/VBoxContainer.add_child(item)

func sort_by_name(item_a: HBoxContainer, item_b: HBoxContainer) -> int:
	print("[inventory.gd:66] sort_by_name() called")
	return -1 if item_a.name < item_b.name else 1 if item_a.name > item_b.name else 0

func apply_filter():
	print("[inventory.gd:70] apply_filter() called")
	for item in inventory_items:
		var category = item.get_meta("category")
		item.visible = (filtered_category == "" or category == filtered_category)

func set_filter(category: String):
	print("[inventory.gd:76] set_filter() called with category: ", category)
	filtered_category = category
	apply_filter()

# Drag-and-Drop
func _on_item_dragged(item_name: String, destination: Node):
	print("[inventory.gd:81] _on_item_dragged() called with item_name: ", item_name, " destination: ", destination.name)
	# Example: interact with destination based on item properties
	destination.receive_item(item_name)

func display_item_description(item_name: String):
	print("[inventory.gd:85] display_item_description() called with item_name: ", item_name)
	var description = get_item_description(item_name)
	$DescriptionLabel.text = description

func get_item_description(item_name: String) -> String:
	print("[inventory.gd:89] get_item_description() called with item_name: ", item_name)
	# Example item descriptions
	match item_name:
		"Red Crystal":
			return "A glowing red crystal filled with energy."
		"Blue Crystal":
			return "A cool blue crystal that feels cold to the touch."
		_:
			return "An unknown item."
