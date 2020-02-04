extends KinematicBody
#thanks to Jeremy Bullock's 3D Godot tutorial for this character movement
#and thanks to coffeecat for working with me on this 3D camera movement

export var CameraRotation: Vector3 = Vector3(0,0,0)
export var speed = 700
export var gravity = -20

var direction = Vector3() #our intended movement
var velocity = Vector3()  #our actual velocity
var position = Vector3() #our current positon

#camera movement
const MOUSE_SENSITIVITY = 0.005 # some value you set
const NORMALIZATION_CONSTANT = 10 #ask coffeecat more about this???
onready var camera = $camjoint #Spatial node with a clippedcamera child
var debug_mouse: bool = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		if debug_mouse:
			#print((event.relative.x * MOUSE_SENSITIVITY) as String + ", " + (event.relative.y * MOUSE_SENSITIVITY) as String)
			print("CameraRotation: " + CameraRotation as String)
		CameraRotation.y += (event.relative.x * MOUSE_SENSITIVITY)
		CameraRotation.x += (event.relative.y * MOUSE_SENSITIVITY)
		CameraRotation.x = clamp(CameraRotation.x, -1.5, 1.5)		

#kinematicbody physics
func _physics_process(delta):
	direction = Vector3(0, 0, 0)
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("forward"):
		direction.z -= 1
	if Input.is_action_pressed("brake"):
		direction.z += 1
	if Input.is_action_pressed("jump"):
		if is_on_floor():
			velocity.y = 9
	direction = direction.normalized()
	direction = direction * speed * delta
	#velocity calculations:
	velocity.x = direction.x
	velocity.z = direction.z
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector3(0, 1, 0))
	#movements related to collisions:
	var hitcount = get_slide_count()
	if hitcount > 0:
		var collision = get_slide_collision(0)
		#impulse vector3 position is the direction and vector3 impulse is the power
		if collision.collider is RigidBody:
			collision.collider.apply_impulse(collision.position, -collision.normal)
	$camjoint.rotation = CameraRotation
