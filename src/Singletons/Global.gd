extends Node

#Global.goto_scene("res://FOLDER/SCENENAME.tscn")

#required for scene switching
var current_scene = null
#var stage = "currentlevel" # for quick reference
#var score: int = 0

func _ready():
	var root = get_tree().get_root() #Global needs to be able to call functions of the root
	current_scene = root.get_child(root.get_child_count() - 1) #returns a zero-indexed child count

func goto_scene(path):
	call_deferred("_deferred_goto_scene", path) #we must call deferred, or else our code will be interrupted when we switch scenes and cause crashes

func _deferred_goto_scene(path): #it is now safe to remove the current scene
	current_scene.free() #delete old scene
	var s = ResourceLoader.load(path) #load the new scene
	current_scene = s.instance() #instance the new scene
	get_tree().get_root().add_child(current_scene) #add it to the active scene, as a child of root
	print("scene loaded at " + OS.get_time(true) as String)
	#fadebackin()
