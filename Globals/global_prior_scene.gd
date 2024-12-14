# Goes to the prior scene
extends Node

var scene_history: Array[PackedScene] = []

# Method to push a scene onto the history stack
func push_scene(scene_name: PackedScene):
	if scene_name:
		scene_history.append(scene_name)
	else: 
		printerr("Null name")

# Method to pop the last scene
func pop_scene() -> PackedScene:
	if scene_history.size() > 0:
		return scene_history.pop_back()
	return null
