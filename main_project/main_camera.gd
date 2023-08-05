extends Camera2D
signal pause_open(current_position)
signal pause_close

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var window_position = DisplayServer.window_get_position()
	var screen_size = DisplayServer.screen_get_usable_rect().size - DisplayServer.window_get_size()/2
	
	#print(DisplayServer.screen_get_usable_rect())
	#+
	
	print(DisplayServer.window_get_size_with_decorations())
	print(DisplayServer.screen_get_usable_rect().size)
	print(window_position)
	position = Vector2i(int(window_position[0]*(256.0-32)/screen_size[0]), int(window_position[1]*(128.0-32)/screen_size[1]))+Vector2i(32, 32)
	if Input.is_action_pressed("esc"):
		pause_open.emit(position)
	if Input.is_action_pressed("click"):
		pause_close.emit()
	print(position)
