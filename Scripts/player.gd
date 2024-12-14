extends CharacterBody2D
class_name player

signal game_started

# Resource: Youtube: Kilo Galaxia, Point & Click Adventure Game with Godot Tutorial - Advanced Character Motion
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

# Player movement
@export var move_speed: float = 200.0 # movement speed  
@export var gravity: float = 1000.0   # speed of fall
@export var max_fall_speed: float = 2500.0 # end speed of fall
@export var jumpForce: float = 250000.0 # hieght of jump
@export var max_jump: int = 2 # max jumps allowed
@export var reset_position: Vector2 = Vector2(234, 621) # Beginning player position

# Game 
var started = false 
var day_timer: float = 0.0

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

enum{IDLE, JUMP, WALK, INTERACT, STOP} # could change

var state = IDLE

var is_going_to_interact: bool # reach dest
var interactable_object: Node = null

# Inventory
var inventory: Array = []
var collision_shape: CollisionShape2D = null

func _ready():
	add_to_group("Player")
	change_state(IDLE)
	destination = position
	day_timer = 0.0  # Reset timer at start

func _process(delta):
	var distance_to_destination = position.distance_to(destination)
	if (distance_to_destination != destination.x) and distance_to_destination > margin:
		distance = Vector2(destination - position)
		# Check if the character is close enough to stop
		if distance_to_destination > margin:
			# Move towards destination
			velocity = distance.normalized() * move_speed
			change_state(WALK)
			move_and_slide()
	else:
		# Stip and reset
		velocity = Vector2.ZERO
		position = destination # Snap to destination to avoid overshooting
		change_state(IDLE)
	
	if velocity.length() > 0:
		# Update sprite orientation based on movement direction
		update_sprite_direction(destination, position)

func _input(event: InputEvent) -> void:
	# Handle the user input
	if Input.is_action_pressed("ui_left_mouseclick"):
		destination = get_global_mouse_position()
		snap_position.x = destination.x
		snap_position.y = position.y

func update_sprite_direction(destination, position):
	# Flip sprite only if the character is moving and the destination is significant
	var direction = destination - position
	if direction.length() > margin:
		if direction.x > 0:
			$AnimatedSprite2D.flip_h = false  # Face right
		elif direction.x < 0:
			$AnimatedSprite2D.flip_h = true  # Face left

func stop():
	change_state(STOP)
	gravity = 0 
	velocity = Vector2.ZERO

func _on_item_collected(body):
	print('_on_item_collected')
	# If an item is collected then
	# update the visual to see what the item is
	# play a sound effect
	# Handle item collection
	if body.is_in_group("Collectible"):
		inventory.append(body.name) # Add the item to the inventory
		body.queue_free() # Remove the item from the scene
		print("Collected item:", body.name)
		# Play sound or visual feedback here

func change_state(newState):
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
