extends CharacterBody2D

class_name player

signal game_started

# Player movement
@export var move_speed: float = 2800.0 # movement speed  
@export var gravity: float = 1000.0   # speed of fall
@export var max_fall_speed: float = 2500.0 # end speed of fall
@export var jumpForce: float = 250000.0 # hieght of jump
@export var max_jump: int = 2 # max jumps allowed
@export var reset_position: Vector2 = Vector2(28, 630) # Beginning player position

# Game 
var started = false 
var day_timer: float = 0.0

# Player health
var health: int = 10
var process_input = true

# Player movement
var destination = Vector2( )
var distance = Vector2( )
var jump_count: int = 0  # number of jumps

func _ready():
	add_to_group("Player")
	$AnimatedSprite2D.play("Idle")
	destination = position
	day_timer = 0.0  # Reset timer at start

func _physics_process(delta):
	## Apply gravity if the player is not on the floor
	#if !is_on_floor():
		#$AnimatedSprite2D.play("Jump")
		#velocity.y += gravity * delta
		#velocity.y = clamp(velocity.y, -max_fall_speed*delta, max_fall_speed*delta) # Cap the fall speed to max_fall_speed
	#else:
		#$AnimatedSprite2D.play("Walk")
		#jump_count = 0 # Rest jumps when on floor
	#
	## jump and game start logic 
	#if Input.is_action_just_pressed("Jump") and jump_count < max_jump and process_input:
		## Check that the game has started
		#print("Jump_count ", jump_count, " max_jump: ", max_jump)
		#if !started:
			#$AnimatedSprite2D.play("Walk")
			#game_started.emit()
			#started = true
		#else:
			#jump(delta)
	
	if Input.is_action_pressed("ui_left_mouseclick"):
		destination = get_global_mouse_position()
	
	# Move towards the destination on the x-axis
	if position.distance_to(destination) != destination.x:
		# calculate distance to the destination
		distance = (destination - position).normalized()
		velocity.x = distance.x * move_speed * delta
	else:
		# movement stops when destination is hit
		velocity.x = 0
	
	if destination.x > position.x:
		$AnimatedSprite2D.flip_h = false # Face right
	if(destination.x < position.x):
		$AnimatedSprite2D.flip_h = true # face left
	
	# move the character
	move_and_slide()
	
	# Player health checked and reset
	check_health(delta)

func jump(delta):
	$AnimatedSprite2D.play("Jump")
	if (jump_count == 0):
		velocity.y = -jumpForce * delta #set jump velocity
	elif (jump_count == 1):
		velocity.y += -jumpForce* delta #set jump velocity
	jump_count += 1 #increment the jump count

func check_health(delta):
	# Check if player has taken damage
	if health <= 3:
		print("Player has taken damage, resetting position.")
		position = reset_position

func die():
	process_input = false

func stop():
	$AnimatedSprite2D.stop()
	gravity = 0 
	velocity = Vector2.ZERO

func _on_item_collected(body):
	# If an item is collected then
	# update the visual to see what the item is
	# play a sound effect
	pass

func take_damage(dam: int) -> void:
	#Implement this later 
	print("Damage to player! Remaining health", health)
	health -= dam
	#if health <= 0:
		#Game_Over()

func game_over():
	pass
