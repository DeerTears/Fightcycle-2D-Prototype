extends Node2D
#temporary debug 
#this script will eventually hosue the main menu or something lmao

func _process(_delta:float) -> void:
	$CanvasLayer/Label.text = ("Sprinting: " + $Car.sprinting as String)
	$CanvasLayer/Label2.text = ("Slipping: " + $Car.slipping as String)
