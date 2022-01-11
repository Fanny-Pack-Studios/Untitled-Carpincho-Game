extends KinematicBody

var velocity = Vector3.ZERO
var gravity = 8

func _physics_process(delta):
	velocity.y -= gravity * delta
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if is_on_floor() && Input.is_action_just_pressed("jump"):
		velocity.y = 5


func _ready():
	$"Character-old-rig/AnimationPlayer".get_animation("Walking").loop = true
	$"Character-old-rig/AnimationPlayer".play("Walking")


