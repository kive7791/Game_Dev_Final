extends Node2D

signal pause_game
signal lost_timeout_game
signal correct_items_collected
signal wrong_items_collected

enum BackgroundState { DAY, NIGHT, NIGHTWLIGHTS }

#Not used at the moment
@onready var line2D: Line2D = $Line2D
@onready var navigation_region: NavigationRegion2D = $NavigationRegion2D
@onready var Player: CharacterBody2D = $Player
@onready var Collectable: Area2D = $Crystal
@onready var Lights: Area2D = $light_event
@onready var Lights_Sprite: Sprite2D = $light_event/Sprite2D
@onready var Rug: Area2D = $rug_event
@onready var Rug_Sprite: Sprite2D = $rug_event/Sprite2D
@onready var Paper: Area2D = $Paper
@onready var Pic: Area2D = $pic_event
@onready var Pic_Sprite: Sprite2D = $pic_event/Sprite2D
@onready var Blue_key: Area2D = $Key
@onready var background: Sprite2D = $Background/Sprite2D

var new_path: PackedVector2Array = PackedVector2Array()
var current_state = BackgroundState.DAY
var lights_on = false  # Keeps track of light state

func _ready() -> void:
	$GameplayTimer.stop()  # Ensure timer is stopped initially
	$GameplayTimer.one_shot = true  # Timer will not loop
	Player.connect("game_started", Callable(self, "_on_level_game_started"))
	Player.connect("correct_items_collected", Callable(self, "_on_level_correct_started"))
	Player.connect("wrong_items_collected", Callable(self, "_on_level_wrong_started"))
	$GameplayTimer.connect("timeout", Callable(self, "_on_gameplay_timer_timeout"))
	
	# Making a item events so I can check if it is being clicked on
	Lights.visible = false
	Lights.connect("light_event", Callable(self, "_on_light_event_triggered"))
	Rug.connect("rug_event", Callable(self, "_on_rug_event_triggered"))
	Paper.visible = false
	Pic.connect("pic_event", Callable(self, "_on_pic_event_triggered"))
	Blue_key.visible = false

func _input(event: InputEvent) -> void:
	# TODO Defined area for the player to move
	if !Input.is_action_pressed("ui_left_mouseclick"):
		return
	
	calculated_mouse_to_target()

func calculated_mouse_to_target():
	var start_position = Player.global_position
	var target_position = get_global_mouse_position()  # Get the mouse position in global space
	
	if navigation_region:
		# Get the navigation map from the region
		var nav_map = navigation_region.get_navigation_map()
		if nav_map:
			# Use the NavigationServer2D to calculate the path
			new_path = NavigationServer2D.map_get_path(nav_map, start_position, target_position, false)
			
			if new_path.size() > 0:
				Player.path = new_path
				line2D.points = new_path
				Player.change_state(Player.WALK)
				#print("Path found:", new_path)
			else:
				print("No path could be found from", start_position, "to", target_position)
		else:
			print("Navigation map not found!")
	else:
		print("NavigationRegion2D not found!")

func _on_level_game_started():
	print("Level_1: Game started!")
	$GameplayTimer.start()  # Start the timer

func _process(delta):
	# Update a timer display label
	if $GameplayTimer.is_stopped() == false:
		# Convert total seconds into minutes and seconds
		var time_left = $GameplayTimer.time_left
		var minutes = int(time_left / 60)
		var seconds = int(time_left) % 60
		
		# Update the TimerLabel with minutes and seconds
		$TimerLabel.text = "%02d:%02d" % [minutes, seconds]
		
		# Check the timer and change the background state
		if time_left <= 150 and current_state == BackgroundState.DAY:
			Lights.visible = true
			change_background_state(BackgroundState.NIGHT)

func change_background_state(new_state):
	current_state = new_state
	
	match current_state:
		BackgroundState.DAY:
			background.texture = preload("res://Assets/Background/bedroom.png")  # Day background
			#light_button.visible = false
		
		BackgroundState.NIGHT:
			background.texture = preload("res://Assets/Background/bedroom_nolight.png")  # Night background
			#light_button.visible = true  # Allow user to turn on lights
		
		BackgroundState.NIGHTWLIGHTS:
			background.texture = preload("res://Assets/Background/bedroom_light.png")  # Night with lights

func _on_gameplay_timer_timeout() -> void:
	print("Time ran out! Player loses.")
	emit_signal("lost_timeout_game")

func _on_level_correct_started() -> void:
	print("level_1_scene on_correct_items")
	emit_signal("correct_items_collected")

func _on_level_wrong_started() -> void:
	print("level_1_scene on_correct_items")
	emit_signal("wrong_items_collected")

func _on_pause_pressed() -> void:
	print("level_1_screen _on_pause_pressed")
	emit_signal("pause_game")

func _on_light_event_triggered() -> void:
	if current_state == BackgroundState.NIGHT or current_state == BackgroundState.NIGHTWLIGHTS:
		lights_on = !lights_on  # Toggle the light state
		if lights_on:
			print("Lights turned ON!")
			Lights_Sprite.texture = preload("res://Assets/Collectable/Light/lights_bedroom_light.png")  # Light Night background 
			change_background_state(BackgroundState.NIGHTWLIGHTS)
		else:
			print("Lights turned OFF!")
			Lights_Sprite.texture = preload("res://Assets/Collectable/NoLight/lights_bedroom_nolight.png")  # Lights off Night background
			change_background_state(BackgroundState.NIGHT)

func _on_rug_event_triggered() -> void:
	if current_state == BackgroundState.DAY:
		print("Rug clicked, pull")
		Rug_Sprite.texture = preload("res://Assets/Collectable/bedroom/Rug_pulled_bedroom.png")
		if is_instance_valid(Paper):
			Paper.visible = true
		else:
			print("Paper collected already")
	else:
		print("Sorry, their is an invisible force, not allowing for this")

func _on_pic_event_triggered() -> void:
	if current_state == BackgroundState.DAY:
		print("Picture clicked, pull down. Is key viible: ", Blue_key.visible)
		Pic_Sprite.texture = preload("res://Assets/Collectable/bedroom/pic_moved_bedroom.png")
		if is_instance_valid(Blue_key):
			Blue_key.visible = true
			print("Here", Blue_key.visible)
		else:
			print("Key collected already")
	else:
		print("Sorry, their is an invisible force, not allowing for this")

func _on_crystal_collectable_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !Input.is_action_pressed("ui_left_mouseclick"):
		return

	Player.is_going_to_interact = true
	Player.interactable_object = Collectable.get_child(shape_idx)
