extends KinematicBody2D

#guide to customize this car script

#step 1. measure the sprite for the length between wheels
var wheel_base: float = 100#length of the sprite's wheel base from frontwheel origin to backwheel origin
#step 2. determine how far the wheels turn in degrees
var steer_angle: float = 15 #degrees we turn at max input
#step 3. tweak speed/power numbers
var engine_power: int = 1800 #acceleration amount (affects turning radius)
var speed: float = 600 #sole movement speed
#step 4. adjust drag based on car type (lower = more aerodynamic)
var drag = -0.001 #amount the air slows us, based on the square of our velocity. drag becomes more significant at high speed
#step 5. determine how powerful the brakes are
var braking = -450 #how fast the brakes reduce our velocity
var slip_speed = 400
var traction_fast = 0.1
var traction_slow = 0.7

#define reverse speed cap
var max_speed_reverse = 600
#friction will be adjusted based on the material we're driving on later, here's a starting number
var friction = -0.9 #amount the ground slows us, the faster we go, the more friction we have

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var steer_direction = 0 #direction of our front wheel

func _physics_process(delta: float) -> void:
	acceleration = Vector2.ZERO
	TakeInput()
	ApplyFriction()
	WheelsCalc(delta)
	velocity += acceleration * delta
	velocity = move_and_slide(velocity)

func ApplyFriction():
	if velocity.length() < 5: #rounding
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	acceleration += drag_force + friction_force

func TakeInput():
	var turn = 0 #no key pressed
	if Input.is_action_pressed("steer_right"):
		turn += 1
	if Input.is_action_pressed("steer_left"):
		turn -= 1
	steer_direction = turn * deg2rad(steer_angle)
	if Input.is_action_pressed("gas"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * braking


func WheelsCalc(delta: float):
	var rear_wheel = position - transform.x * wheel_base/2.0 #half the wheelbase behind the car's origin
	var front_wheel = position + transform.x * wheel_base/2.0 #half the wheelbase in front of the car's origin
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0: #going forward
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
	if d < 0: #going in reverse
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()
