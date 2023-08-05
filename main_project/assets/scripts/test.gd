extends Node2D
var hasClicked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var size = min(2500, 1000)
	var screen_size = min(DisplayServer.screen_get_size()[0], DisplayServer.screen_get_size()[1])
	var window_size = int((64 / float(size)) * screen_size)
	print(window_size)
	print(screen_size)
	
	DisplayServer.window_set_size(Vector2i(int(screen_size * 0.4), int(screen_size * 0.4)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not hasClicked:
		DisplayServer.window_set_position(DisplayServer.mouse_get_position()-DisplayServer.window_get_size()/2)
	if Input.is_action_pressed("click"):
		hasClicked = true
	"""
	pass
	"""
