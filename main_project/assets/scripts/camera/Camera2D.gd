extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var spd = 10
var radius_required_to_move = 100
func _process(delta):
	
	var mouse_position = DisplayServer.window_get_position()
	var screen_size = DisplayServer.screen_get_usable_rect().size - DisplayServer.window_get_size()
	
	#print(DisplayServer.screen_get_usable_rect())
	#print(DisplayServer.window_get_size_with_decorations())
	#print(DisplayServer.window_get_size())
	position = Vector2i(int(mouse_position[0]*float(1000-64)/screen_size[0]), int(mouse_position[1]*float(1000-64)/screen_size[1])) - Vector2i(0, 342)
	print(position)
