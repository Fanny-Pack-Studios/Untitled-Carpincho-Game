extends Spatial

func _process(delta):
	if Input.is_key_pressed(KEY_Q):
		rotate_y(PI * delta)
	if Input.is_key_pressed(KEY_E):
		rotate_y(-PI * delta)
