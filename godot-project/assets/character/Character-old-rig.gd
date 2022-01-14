extends KinematicBody

var velocity = Vector3.ZERO
var gravity = 10

export var speed: int = 2

onready var camera = $"../Camera"

func _physics_process(delta):
	velocity.y -= gravity * delta
	
	if is_on_floor() && Input.is_action_just_pressed("jump"):
		velocity.y = 4
	
	var input_direction = Input.get_vector("left", "right", "down", "up")
	
	if input_direction != Vector2.ZERO:
		var camera_forward = get_camera_forward_2d()
		print(camera_forward)
		
		input_direction = input_direction.rotated(camera_forward.angle() )
		#print(input_direction)
		rotation = Vector3(0, input_direction.angle(), 0)
		var forward_velocity = speed * global_transform.basis.z
		velocity.x = forward_velocity.x
		velocity.z = forward_velocity.z
	else:
		velocity.x = 0
		velocity.z = 0
		
	velocity = move_and_slide(velocity, Vector3.UP)

func get_camera_forward_2d() -> Vector2: 
	var zbasis = camera.global_transform.basis.z
	return Vector2(-zbasis.x, zbasis.z).normalized()

func _ready():
	pass

