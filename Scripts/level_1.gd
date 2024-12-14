extends Control

#Not used at the moment
#@onready var nav2D: NavigationRegion2D = $NavigationRegion2D
@onready var Player: CharacterBody2D = $Player
@onready var Collectable: Area2D = $crystal_collectable

func _input(event: InputEvent) -> void:
	# TODO Defined area for the player to move
	if !Input.is_action_pressed("ui_left_mouseclick"):
		return

func _on_crystal_collectable_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !Input.is_action_pressed("ui_left_mouseclick"):
		return
		
	Player.is_going_to_interact = true
	Player.interactable_object = Collectable.get_child(shape_idx)
