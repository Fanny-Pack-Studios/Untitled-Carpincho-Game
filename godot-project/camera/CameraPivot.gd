extends Spatial

export(NodePath) var character_to_follow_path: NodePath = @"../Capybara"

onready var character_to_follow: Spatial = get_node(character_to_follow_path)

func _process(delta):
	if Input.is_key_pressed(KEY_Q):
		rotate_y(PI * delta)
	if Input.is_key_pressed(KEY_E):
		rotate_y(-PI * delta)
		
	if is_instance_valid(character_to_follow):
		translation = character_to_follow.translation
