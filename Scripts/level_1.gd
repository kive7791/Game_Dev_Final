extends Node2D

signal pause_game
signal lost_timeout_game

#Not used at the moment
@onready var line2D: Line2D = $Line2D
@onready var navigation_region: NavigationRegion2D = $NavigationRegion2D
@onready var Player: CharacterBody2D = $Player
@onready var Collectable: Area2D = $Crystal

var new_path: PackedVector2Array = PackedVector2Array()

func _ready() -> void:
	$GameplayTimer.stop()  # Ensure timer is stopped initially
	$GameplayTimer.one_shot = true  # Timer will not loop
	Player.connect("game_started", Callable(self, "_on_level_game_started"))
	$GameplayTimer.connect("timeout", Callable(self, "_on_gameplay_timer_timeout"))

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
				print("Path found:", new_path)
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

func _on_gameplay_timer_timeout() -> void:
	print("Time ran out! Player loses.")
	emit_signal("lost_timeout_game")

func _on_pause_pressed() -> void:
	print("level_1_screen _on_pause_pressed")
	emit_signal("pause_game")

func _on_crystal_collectable_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !Input.is_action_pressed("ui_left_mouseclick"):
		return

	Player.is_going_to_interact = true
	Player.interactable_object = Collectable.get_child(shape_idx)
