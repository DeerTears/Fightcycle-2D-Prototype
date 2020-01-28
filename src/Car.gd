extends KinematicBody2D
#setup
var wheel_base: float = 100 #distance from front to back wheels

#personal details
var steer_angle: float = 15 #degrees turned at max input
var engine_power: int = 1150 #acceleration amt
var braking = -700 #lower amt = faster braking
var max_speed_reverse = 600 #limits reverse speed, doesn't increase it
var drag = -0.001 #higher drag = thicker air/bigger car

#traction
var slip_slow = 0.5 #usual traction
var limit_slip = 400 #when exceeded, switch to fast traction
var slip_fast = 0.03 #fast traction
var slipping = false #used for debug only

#sprinting:
var limit_sprint = 1000 #when exceeded, switch to sprint friction/drag
var slip_sprint = 0.25 #bonus sprint traction (im sorry this is really complicated now)

var friction = -0.09 #usual ground friction
var sprint_friction = -0.001
var sprint_turn_multi = 0.4 #keep it below 1
var sprinting = false

#products:
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
	if sprinting:
		friction_force = velocity * sprint_friction
	var drag_force = velocity * velocity.length() * drag
	acceleration += drag_force + friction_force

func TakeInput():
	var turn = 0 #no key pressed
	if Input.is_action_pressed("steer_right"):
		turn = +1
	if Input.is_action_pressed("steer_left"):
		turn = -1
	if sprinting:
		steer_direction = turn * deg2rad(steer_angle * sprint_turn_multi)
	else:
		steer_direction = turn * deg2rad(steer_angle)
	if Input.is_action_pressed("gas"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * braking


func WheelsCalc(delta: float):
	#creating wheels to calculate rotation:
	var rear_wheel = position - transform.x * wheel_base/2.0 #half the wheelbase behind the car's origin
	var front_wheel = position + transform.x * wheel_base/2.0 #half the wheelbase in front of the car's origin
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	
	#calculating traction
	var traction: float = 0.0
	sprinting = false
	slipping = false
	traction = slip_slow #this by default, unless we are...
	if velocity.length() > limit_sprint: #fast enough to sprint?
		traction = slip_sprint
		sprinting = true
	elif velocity.length() > limit_slip: #fast enough to slip?
		traction = slip_fast
		slipping = true
	
	#figuring out direction
	var dir = new_heading.dot(velocity.normalized())
	if dir > 0: #going forward
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
	if dir < 0: #going in reverse
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	
	#finalizing rotation
	rotation = new_heading.angle()
