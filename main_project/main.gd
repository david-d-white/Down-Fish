extends Node2D
var hasEscaped = false
signal pause_open(position)
signal pause_close
@export var fish_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var size = min(512, 256)
	var screen_size = min(DisplayServer.screen_get_size()[0], DisplayServer.screen_get_size()[1])
	var window_size = int((64 / float(size)) * screen_size)
	#print(window_size)
	#print(screen_size)
	
	DisplayServer.window_set_size(Vector2i(int(window_size), int(window_size)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not hasEscaped:
		var mouse_position = DisplayServer.mouse_get_position()-DisplayServer.window_get_size()/2
		var screen_size = DisplayServer.screen_get_usable_rect().size
		#print(DisplayServer.mouse_get_position())
		mouse_position = Vector2i(max(0, mouse_position[0]), max(0, mouse_position[1]))
		#print(mouse_position)
		#print(screen_size)
		#print(DisplayServer.window_get_size())
		mouse_position = Vector2i(min(screen_size[0]-DisplayServer.window_get_size()[0], mouse_position[0]), min(screen_size[1]-DisplayServer.window_get_size()[1], mouse_position[1]))
		#print(mouse_position)
		DisplayServer.window_set_position(mouse_position)
	if Input.is_action_pressed("esc"):
		hasEscaped = true
	if Input.is_action_pressed("click"):
		hasEscaped = false
