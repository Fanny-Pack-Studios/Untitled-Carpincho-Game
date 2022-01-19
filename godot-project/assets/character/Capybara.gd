extends KinematicBody

var velocity = Vector3.ZERO
var gravity = 10

export var speed: int = 2

onready var camera = $"../CameraPivot/Camera"

var input_direction_3d: Vector3 = Vector3()

func _physics_process(delta):
	
	velocity.y -= gravity * delta
	
	if is_on_floor() && Input.is_action_just_pressed("jump"):
		velocity.y = 4
	
	if input_direction_3d != Vector3.ZERO:
		transform.basis = Basis(input_direction_3d.rotated(Vector3.UP, -PI/2), Vector3.UP, -input_direction_3d)
		
		var forward_velocity = speed * -global_transform.basis.z
		velocity.x = forward_velocity.x
		velocity.z = forward_velocity.z
	else:
		velocity.x = 0
		velocity.z = 0
		
	velocity = move_and_slide(velocity, Vector3.UP)

func _process(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	if input_direction != Vector2.ZERO:
		var camera_forward = get_camera_forward()
		input_direction_3d = Vector3(input_direction.x, 0, input_direction.y).normalized()
		
		input_direction_3d = input_direction_3d.rotated(Vector3.UP, camera_forward.signed_angle_to(Vector3.FORWARD, Vector3.DOWN))
	else:
		input_direction_3d = Vector3.ZERO
		

func get_camera_forward() -> Vector3: 
	var zbasis = camera.global_transform.basis.z
	return -Vector3(zbasis.x, 0, zbasis.z).normalized()

