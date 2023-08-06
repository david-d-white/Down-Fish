extends Camera2D
signal pause_open(current_position)
signal pause_close
var camera_offset = Vector2(0, 0)
var paused = false

const RESOLUTION:int = 64
const SIZE_WINDOWS:Vector2 = Vector2(8,4)
const SIZE_PIXELS = SIZE_WINDOWS*RESOLUTION
const PARALLAX = 1

@onready var play_area:Rect2i = DisplayServer.screen_get_usable_rect()
var window_size:Vector2i
var pan_scale

var window_positions = [Vector2i(0, 0), Vector2i(0,0), Vector2i(0,0)] # Hacky window position buffer to smooth rendering
var camera_disp # Camera displacement for window and camera position calculations

# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.connect("frame_pre_draw", self.update_camera_pos)
	RenderingServer.connect("frame_post_draw", self.update_window_pos)
	
	# Scale Window size to based on monitor size and play area size.
	# Use the minimum value to ensure enough playable area
	var window_width = int(min(play_area.size.x/SIZE_WINDOWS.x, play_area.size.y/SIZE_WINDOWS.y))
	window_width -= window_width%RESOLUTION # Ensure window is a multiple of 64 pixels to keep pixel art compatible
	window_size = Vector2i(window_width, window_width)
	DisplayServer.window_set_size(window_size)
	
	# Calculate playable area
	var play_size = Vector2i(SIZE_WINDOWS*window_width)
	play_area = Rect2i(play_area.get_center() - play_size/2 , play_size)
	
	# Calculate scaling for camera panning
	pan_scale = window_width/RESOLUTION

func update_camera_pos():
	if not paused:	
		var mouse_disp:Vector2 = Vector2(DisplayServer.mouse_get_position() - play_area.get_center())
		
		# Get camera displacement (snapped to pixels)
		camera_disp = mouse_disp / pan_scale
		camera_disp.x = floor(abs(camera_disp.x))*sign(camera_disp.x)
		camera_disp.y = floor(abs(camera_disp.y))*sign(camera_disp.y)

		# Clamp camera displacement to world bounds
		camera_disp.x = clamp(camera_disp.x, -(SIZE_PIXELS.x - RESOLUTION)/2, (SIZE_PIXELS.x - RESOLUTION)/2)
		camera_disp.y = clamp(camera_disp.y, -(SIZE_PIXELS.y - RESOLUTION)/2, (SIZE_PIXELS.y - RESOLUTION)/2)
		
		# ====== Set Camera Position ====== #
		position = Vector2i(camera_disp*PARALLAX + camera_offset)
		
	if Input.is_action_pressed("esc"):
		pause_open.emit(position)
		paused = true
	if Input.is_action_pressed("click"):
		pause_close.emit()
		paused = false

func update_window_pos():
	if not paused:	
		# ====== Set Window Position ====== #
		DisplayServer.window_set_position(window_positions.pop_front())
		window_positions.push_back(play_area.get_center() + Vector2i(camera_disp*pan_scale) - window_size/2)

func _on_boat_move_camera_horiz(amount):
	camera_offset[0] += amount

func _on_boat_move_camera_vert(amount):
	camera_offset[1] += amount
