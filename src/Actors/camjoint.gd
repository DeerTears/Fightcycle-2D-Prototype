extends Spatial

#yet to do:
#1. test out everything that's already written [almost done]
#2. inquire about what "set position here" at the end means. the camera? the player?
#3. add clamp() to set min/max speed values for camera rotation, once everything's working

const NORMALIZATION_CONSTANT = 10
var rotation_speed = Vector2() #inputs recieved
var rotation_current = Vector2() #the rotation to be executed though the methods

#this script controls the motion of the clipped camera

func rotate_horizontally(amount: float):
	rotation_speed.x += amount * NORMALIZATION_CONSTANT

func rotate_vertically(amount: float):
	rotation_speed.y += amount * NORMALIZATION_CONSTANT

func _physics_process(delta):
	# apply other stuff here
	var rotated_amount_in_frame = rotation * delta
	rotation_current.x += rotated_amount_in_frame.x
	rotation_current.y += rotated_amount_in_frame.y
	rotation_speed -= Vector2(rotated_amount_in_frame.x, rotated_amount_in_frame.y)
	rotation_speed = rotation_speed / 1.25
	self.set_identity()
	rotate_y(rotation_current.y)
	rotate_x(rotation_current.x)
	# set position here # did you (coffeecat) mean like...the camera's position? like the raycasted endresult?

#then clamp() to avoid flying off the handle
