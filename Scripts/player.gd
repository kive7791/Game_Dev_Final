extends CharacterBody2D
class_name player

signal game_started
signal crystal_collected(body) # signal - crystal colleced for game

# Resource: Youtube: Kilo Galaxia, Point & Click Adventure Game with Godot Tutorial - Advanced Character Motion

# Player movement
@export var move_speed: float = 200.0 # movement speed  
@export var gravity: float = 1000.0   # speed of fall
@export var max_fall_speed: float = 2500.0 # end speed of fall
@export var jumpForce: float = 250000.0 # hieght of jump
@export var max_jump: int = 2 # max jumps allowed
@export var reset_position: Vector2 = Vector2(234, 621) # Beginning player position

# Player health
var health: int = 10
var process_input = true

# Player movement
var destination: Vector2 = Vector2.ZERO
var distance: Vector2
var snap_position: Vector2
var jump_count: int = 0  # number of jumps
var navigation_region: NavigationRegion2D = null
var margin = 5
var has_moved: bool = false
var path: PackedVector2Array = PackedVector2Array()  # The path to follow

enum{IDLE, JUMP, WALK, INTERACT, STOP} # could change

var state = IDLE

var is_going_to_interact: bool # reach dest
var interactable_object: Node = null

# Inventory
var inventory: Array = []

# Reference to the inventory UI label
var inventory_label = null

func _ready():
	print("player: _ready")
	add_to_group("Player")
	change_state(IDLE)
	destination = position
	set_inventory_reference()

# Dynamically set the inventory label reference
func set_inventory_reference():
	print("player: set_inventory_reference")
	connect("crystal_collected", Callable(self, "_on_item_collected"))
	var current_scene = get_parent()
	print("player: current_scene ", current_scene.name)
	if current_scene:
		print("player: current_scene children ", current_scene.get_children())
		# Use a specific known class like InventoryPanel
		for child in current_scene.get_children():
			print("player: child ", child.name)
			if child.name == "InventoryPanel":
				inventory_label = child.get_node("ScrollContainer/VBoxContainer")
				break
	print("player: inventory: ", inventory)

func _process(delta):
	match state:
		IDLE:
			pass
		WALK:
			move_along_path(delta)

func move_along_path(delta):
	if path.size() == 0:
		change_state(IDLE)
		return
	
	var move_distance = move_speed * delta
	var starting_point = position
	var next_point = path[0] #only accessed if path.size() > 0
	var direction = (next_point - starting_point).normalized()
	var distance_to_next = starting_point.distance_to(path[0])
	
	
	if move_distance < distance_to_next:
		if direction != Vector2.ZERO and not has_moved:
			has_moved = true
			emit_signal("game_started")  # Emit the signal only once
			print("Player has started moving. Signal emitted.")
		# move
		velocity = direction * move_speed
	else:
		velocity = Vector2.ZERO
		path = path.slice(1) # Move to nexr point
	
	if path.size() == 0:
			change_state(IDLE)
	else:
		position += velocity * delta
		update_sprite_direction(starting_point)
	
	_draw()

func _draw():
	# Visualize the path for debugging
	if path.size() > 1:
		for i in range(path.size() - 1):
			draw_line(path[i], path[i + 1], Color.GREEN, .5)

func update_sprite_direction(starting_point):
	# Flip sprite only if the character is moving and the destination is significant
	if starting_point.x < path[0].x:
		$AnimatedSprite2D.flip_h = false  # Face right
	elif starting_point.x > path[0].x:
		$AnimatedSprite2D.flip_h = true  # Face left

func stop():
	print("player: stop")
	change_state(STOP)
	gravity = 0 
	velocity = Vector2.ZERO

func _on_item_collected(body: Node2D):
	print("player: _on_item_collected with ", body.name)
	# If an item is collected then
	# update the visual to see what the item is
	# play a sound effect
	# Handle item collection
	if body.is_in_group("Collectible"):
		body.queue_free() # Remove the item from the scene
		print("Collected item: ", body.name)
		add_to_inventory(body)
		# Play sound or visual feedback here

func change_state(newState):
	#print("player: change_state", newState)
	#DO NOTHING
	if state == newState:
		return 
	
	# Change STATE
	state = newState
	
	match state:
		IDLE:
			$AnimatedSprite2D.play("Idle")
		JUMP:
			$AnimatedSprite2D.play("Jump")
		WALK:
			$AnimatedSprite2D.play("Walk")
		INTERACT:
			$AnimatedSprite2D.play("Interact")
			print("Interacted!!")
		STOP:
			$AnimatedSprite2D.stop()

# Function to add an item to the inventory
func add_to_inventory(item: Node2D):
	print("player: inventory items: ", inventory)
	print("player: add_to_inventory: ", item.name)
	# Check if the item is already in inventory
	if item.name not in inventory:
		print("player: append inventory ", item.name)
		inventory.append(item.name) # Add the item to the inventory
		add_item_to_ui(item)

# Add a single item to the UI
func add_item_to_ui(item: Node2D):
	print("player: add_item_to_ui ", item.name)
	print("player: inventory_label ", inventory_label)
	if inventory_label:
		var item_hbox = HBoxContainer.new()
		item_hbox.name = item.name

		# Add item image
		var item_image = TextureRect.new()

		var item_sprite : Texture = null
		# Use a specific known class like AnimatedSprite2D
		for child in item.get_children():
			print("player: child ", child.name)
			if child.name == "AnimatedSprite2D":
				item_sprite = child.sprite_frames.get_frame_texture(child.animation, child.frame)
				break
		print("player: item ", item_sprite)
		if not item_sprite:
			print("Warning: Sprite not found for ", item.name)
			return

		item_image.texture = item_sprite
		item_image.custom_minimum_size = Vector2(32, 32)  # Set icon size correctly
		item_hbox.add_child(item_image)

		# Add item name
		var item_label = Label.new()
		item_label.text = item.name
		item_hbox.add_child(item_label)

		inventory_label.add_child(item_hbox)

# Example function for item interaction with a collectable item
func _on_collectable_item_clicked(item_name):
	print("player: _on_collectable_item_clicked", item_name)
	add_to_inventory(item_name)  # Add item to inventory when clicked
	# Trigger sound or visual effect
	var sound = AudioStreamPlayer.new()
	sound.stream = preload("res://Assets/SoundEffects/clicking-interface-select-201946.mp3")
	add_child(sound)
	sound.play()
	self.queue_free()  # Remove the item from the scene after collection

# Example check for inventory completion
func check_inventory_for_end_game():
	print("player: check_inventory_for_end_game")
	if "Red Crystal" in inventory and "Blue Crystal" in inventory:
		trigger_true_ending()
	else:
		trigger_bad_ending()

func trigger_true_ending():
	print("Congratulations! You found all items!")
	# Transition to true ending scene or display message

func trigger_bad_ending():
	print("You missed some items...")
	# Transition to bad ending scene or display message

# old code for player movement:
#func _old(delta):
	#var distance_to_destination = position.distance_to(destination)
	#if (distance_to_destination != destination.x) and distance_to_destination > margin:
		#distance = Vector2(destination - position)
		## Check if the character is close enough to stop
		#if distance_to_destination > margin:
			 ## Check if the player has moved for the first time
			#if distance != Vector2.ZERO and not has_moved:
				#has_moved = true
				#emit_signal("game_started")  # Emit the signal only once
				#print("Player has started moving. Signal emitted.")
			## Move towards destination
			#velocity = distance.normalized() * move_speed
			#change_state(WALK)
			#move_and_slide()
	#else:
		## Stip and reset
		#velocity = Vector2.ZERO
		#position = destination # Snap to destination to avoid overshooting
		#change_state(IDLE)
	#
	#if velocity.length() > 0:
		## Update sprite orientation based on movement direction
		#update_sprite_direction(destination, position)
