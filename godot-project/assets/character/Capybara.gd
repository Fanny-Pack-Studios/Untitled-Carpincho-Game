extends KinematicBody

var velocity = Vector3.ZERO
var gravity = 15

export(float) var running_speed: float = 2.6
export(float) var walking_speed: float = 0.8

var walking: bool = false

export(NodePath) var camera_path: NodePath = @"../CameraPivot/Camera"

onready var camera: Camera = get_node(camera_path)

var input_direction_3d: Vector3 = Vector3()

export(float) var turn_speed: float = 5 * PI

onready var animation_player = $CapybaraModel/AnimationPlayer

export(float) var jump_control_time = 0.2
var remaining_jump_control = 0

export(float) var jump_speed = 4.5

func _physics_process(delta):
	velocity.y -= gravity * delta
	
	if is_on_floor() && Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed
		remaining_jump_control = jump_control_time
		
	if remaining_jump_control > 0:
		remaining_jump_control -= delta
		if Input.is_action_pressed("jump"): 
			velocity.y = jump_speed
	
	if input_direction_3d != Vector3.ZERO:
		animation_player.play("Walking" if walking else "Running")
		
		var target_quat = Quat(Basis(input_direction_3d.rotated(Vector3.UP, -PI/2), Vector3.UP, -input_direction_3d))
		var current_quat = Quat(transform.basis.orthonormalized())
		
		var angleDiff = target_quat.angle_to(current_quat)
	
		var max_delta_rotation = turn_speed * delta
		
		if(max_delta_rotation >= angleDiff):
			current_quat = target_quat
		else:
			var weight = max_delta_rotation / angleDiff
			
			current_quat = current_quat.slerp(target_quat, weight)
			
		var scale = transform.basis.get_scale()
		
		transform.basis = Basis(current_quat).scaled(scale) 

		#transform.basis = Basis(current_front_vector.rotated(Vector3.UP, -PI/2), Vector3.UP, -current_front_vector)
		
		var forward_velocity = get_speed() * -global_transform.basis.z
		velocity.x = forward_velocity.x
		velocity.z = forward_velocity.z
	else:
		animation_player.play("Idle Pose")
		velocity.x = 0
		velocity.z = 0
		
	velocity = move_and_slide(velocity, Vector3.UP, true)

func get_speed():
	return walking_speed if walking else running_speed

func _process(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	if input_direction != Vector2.ZERO:
		var camera_forward = get_camera_forward()
		input_direction_3d = Vector3(input_direction.x, 0, input_direction.y).normalized()
		
		input_direction_3d = input_direction_3d.rotated(Vector3.UP, camera_forward.signed_angle_to(Vector3.FORWARD, Vector3.DOWN))
	else:
		input_direction_3d = Vector3.ZERO
		
	walking = Input.is_action_pressed("walking")
		

func _ready():
	animation_player.playback_default_blend_time = 0.15
	DebugOverlay.add_vector(self, "input_direction_3d")

func get_camera_forward() -> Vector3: 
	var zbasis = camera.global_transform.basis.z
	return -Vector3(zbasis.x, 0, zbasis.z).normalized()

