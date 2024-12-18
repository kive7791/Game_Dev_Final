extends Node2D

# Scene references
@export var player_scene: PackedScene # Assign the Soldier scene in the editor
@export var game_over_scene: PackedScene # Assign the Game Over scene in the editor
@export var intro_scene: PackedScene # Assign the Introduction scene in the editor
@export var credit_scene: PackedScene # Assign the Credit scene in the editor
@export var backstory_scene: PackedScene # Assign the Backstory scene in the editor
@export var pause_scene: PackedScene # Assign the Pause scene in the editor
@export var hint_scene: PackedScene # Assign the Hint scene in the editor
@export var hint_overall_scene: PackedScene # Assign the Hint overall scene in the editor
@export var hint_order_scene: PackedScene # Assign the Hint order scene in the editor
@export var level_scenes: Array[PackedScene] = [
	preload("res://Scenes/level_1.tscn")
]
@export var bg_music: Resource # Background music

# Game state
var current_level: int = 0              # Tracks the current level index
var current_scene: Node = null          # Tracks the current active scene
var player_health: int = 100            # Player's health
var is_game_over: bool = false          # Game over state

func _ready() -> void:
	print("Game started!")
	if bg_music:
		if GlobalAudioManager:
			GlobalAudioManager.play_track(bg_music, 0.5)
		else:
			print("GlobalAudioManager not initialized.")
	else:
		print("bg_music is not set.")
	
	_start_intro()

func _start_intro() -> void:
	print("Game _start_intro")
	
	# Load the intro scene
	if current_scene:
		current_scene.queue_free()
	current_scene = intro_scene.instantiate()
	print("main: current_scene ", current_scene.name, current_scene.get_index())
	add_child(current_scene)
	
	if GlobalPriorScene:
			GlobalPriorScene.push_scene(intro_scene)
			print("Pushed intro_scene")
	else:
		print("GlobalPrior not initialized.")
	
	current_scene.connect("start_backstory_game", Callable(self, "_on_backstory_game"))
	current_scene.connect("credit_game", Callable(self, "_on_credit_game"))
	current_scene.connect("quit_game", Callable(self, "_on_quit_game"))

func _on_start_game() -> void:
	print("Game _on_start_game")
	load_level(0)

func _on_restart_game() -> void:
	print("Game _on_restart_game")
	cleanup()
	current_scene.queue_free() # Remove the intro scene after starting the game
	current_level = 0
	player_health = 100 
	load_level(0)

func _on_backstory_game() -> void:
	print("Game _on_backstory_game")
	if current_scene:
		current_scene.queue_free()
	current_scene = backstory_scene.instantiate()
	get_parent().add_child(current_scene)
	current_scene.connect("back_game", Callable(self, "_on_back_game"))
	current_scene.connect("start_game", Callable(self, "_on_start_game"))

func _on_credit_game() -> void:
	print("Game _on_credit_game")
	if current_scene:
		current_scene.queue_free()
	current_scene = credit_scene.instantiate()
	print("main: current_scene ", current_scene.name, current_scene.get_index())
	get_parent().add_child(current_scene)
	current_scene.connect("back_game", Callable(self, "_on_back_game"))
	current_scene.connect("quit_game", Callable(self, "_on_quit_game"))

func _on_back_game() -> void:
	var previous_scene = GlobalPriorScene.pop_scene()
	if previous_scene:
		mine_change_scene(previous_scene)
	else:
		print("No previous scene found in history stack.")

func mine_change_scene(new_scene_path: PackedScene):
	print("Current stack:", GlobalPriorScene.scene_history)
	# Push the current scene's resource path to history
	if GlobalPriorScene and (!current_scene.name.is_empty()):
		GlobalPriorScene.push_scene(new_scene_path)
		print("Pushed to stack:", new_scene_path)
	
	print("Current stack:", GlobalPriorScene.scene_history)
	# Free the current scene
	if current_scene:
		current_scene.queue_free()
	
	# Load and instantiate the new scene
	current_scene = new_scene_path.instantiate()
	get_parent().add_child(current_scene)
	
	# This has the potential of not working, because not always is these signals connected
	current_scene.connect("start_backstory_game", Callable(self, "_on_backstory_game"))
	current_scene.connect("credit_game", Callable(self, "_on_credit_game"))
	current_scene.connect("quit_game", Callable(self, "_on_quit_game"))
	current_scene.connect("pause_game", Callable(self, "_on_pause_game"))
	current_scene.connect("restart_game", Callable(self, "_on_restart_game"))
	
	print("Current stack:", GlobalPriorScene.scene_history)

func _on_quit_game() -> void:
	print("Game _on_quit_game")
	# Quits the game.
	get_tree().quit()

func load_level(level_index: int) -> void:
	print("Game _load_level")

	#if current_level >= level_scenes.size():
		#end_game("YOU WIN!")  # End game if all levels are completed
		#return

	# Free current scene if necessary
	if current_scene:
		current_scene.queue_free()
		#GlobalPriorScene.pop_scene()
	current_level = level_index

	# Load the level scene
	current_scene = level_scenes[level_index].instantiate()
	print("main: current_scene ", current_scene.name, " ", current_scene.get_index(), " ", current_scene.get_children())
	get_parent().add_child(current_scene)
	GlobalPriorScene.push_scene(level_scenes[level_index])
	print("Pushed level_scene")

	current_scene.connect("correct_items_collected", Callable(self, "show_game_winner_over"))
	current_scene.connect("wrong_items_collected", Callable(self, "show_game_loser_over"))
	current_scene.connect("pause_game", Callable(self, "_on_pause_game"))
	current_scene.connect("lost_timeout_game", Callable(self, "_on_lost_timeout_game"))

func _on_pause_game() -> void:
	print("Game _on_pause_game")
	if current_scene:
		current_scene.queue_free()
		#GlobalPriorScene.pop()
	current_scene = pause_scene.instantiate()
	get_parent().add_child(current_scene)
	
	current_scene.connect("back_game", Callable(self, "_on_back_game"))
	current_scene.connect("quit_game", Callable(self, "_on_quit_game"))
	current_scene.connect("hint_game", Callable(self, "_on_hint_game"))
	current_scene.connect("restart_game", Callable(self, "_on_restart_game"))

func _on_hint_game() -> void:
	print("Game _on_hint_game")
	if current_scene:
		current_scene.queue_free()
	current_scene = hint_scene.instantiate()
	add_child(current_scene)
	
	current_scene.connect("hint_1_game", Callable(self, "_on_hint_1_game"))
	current_scene.connect("hint_2_game", Callable(self, "_on_hint_2_game"))
	current_scene.connect("back_game", Callable(self, "_on_back_game"))

# TODO add functionality of the hints
# Hint to show all items in the room
func _on_hint_1_game() -> void:
	print("Game _on_hint_1_game")
	if current_scene:
		current_scene.queue_free()
	current_scene = hint_overall_scene.instantiate()
	add_child(current_scene)
	
	current_scene.connect("hint_1_game", Callable(self, "_on_hint_1_game"))
	current_scene.connect("hint_2_game", Callable(self, "_on_hint_2_game"))
	current_scene.connect("back_game", Callable(self, "_on_back_game"))
	

# Hint to show items order
func _on_hint_2_game() -> void:
	print("Game _on_hint_2_game")
	if current_scene:
		current_scene.queue_free()
	current_scene = hint_order_scene.instantiate()
	add_child(current_scene)
	
	current_scene.connect("hint_1_game", Callable(self, "_on_hint_1_game"))
	current_scene.connect("hint_2_game", Callable(self, "_on_hint_2_game"))
	current_scene.connect("back_game", Callable(self, "_on_back_game"))

#func _on_puzzle_solved() -> void:
	#print("Game _on_puzzle_solved")
	##print("Puzzle Solved! Remaining puzzle: ", puzzle_remaining)
#
#func _on_end_time() -> void:
	#print("Game _on_end_time")
	#end_game("YOU LOST!")

func cleanup() -> void:
	print("Game cleanup")
	for child in get_tree().get_nodes_in_group("dynamic_objects"):
		print("name ", child.name)
		child.queue_free()
	#for level in get_tree().get_nodes_in_group("player"):
		#print("Freeing level:", level.name)
		#level.queue_free()
	for level in get_tree().get_nodes_in_group("enemies"):
		print("Freeing level:", level.name)
		level.queue_free()

func _on_lost_timeout_game() -> void:
	print("Game _on_lost_timeout_game")
	if current_scene:
		current_scene.queue_free()
	current_scene = game_over_scene.instantiate()
	add_child(current_scene)
	
	current_scene.connect("credit_game", Callable(self, "_on_credit_game"))
	current_scene.connect("restart_game", Callable(self, "_on_restart_game"))
	current_scene.connect("quit_game", Callable(self, "_on_quit_game"))

func end_game(message: String) -> void:
	print("Game _end_game")
	show_game_over(message)

func show_game_over(message: String) -> void:
	print("Game _show_game_over")
	if current_scene:
		current_scene.queue_free()
	current_scene = game_over_scene.instantiate()
	add_child(current_scene)
	if current_scene.has_method("set_message"):
		current_scene.set_message(message)
	current_scene.connect("credit_game", Callable(self, "_on_credit_game"))
	current_scene.connect("restart_game", Callable(self, "_on_restart_game"))
	current_scene.connect("quit_game", Callable(self, "_on_quit_game"))

func show_game_winner_over():
	show_game_over("WINNER!")

func show_game_loser_over():
	show_game_over("LOSER...")
