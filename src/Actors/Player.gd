extends Node2D
#currently player is referring to the player sitting inside the car, ready to attack with various weapon options

var weapon: String = ""
var angle_to_mouse = 0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _physics_process(delta: float) -> void:
	var mouse = get_global_mouse_position() #works
	var pos = get_parent().position #works
	var normal = pos.direction_to(mouse) #is insufficient
	$Sprite.rotation = normal.x #no idea how to apply that direction to amount
