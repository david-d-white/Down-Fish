@tool extends Camera2D

# ==== Tool Script Hint ==== #
@export_group("Game Area")
@export var show_hint:bool = true:
	set(new):
		show_hint = new
		queue_redraw()

# ==== Play Area and Screen Size Parameters ==== #
@export var SIZE_WINDOWS:Vector2 = Vector2(14,7):
	set(new):
		SIZE_WINDOWS = new
		SIZE_PIXELS = SIZE_WINDOWS*RESOLUTION
		queue_redraw()
const RESOLUTION:int = 64
var SIZE_PIXELS = SIZE_WINDOWS*RESOLUTION
@export var PARALLAX:float = 1:
	set(new):
		PARALLAX = new
		queue_redraw()
@export_subgroup("Panning Limits") 
@export var NORTH_LIM = 0:
	set(new):
			NORTH_LIM = new
			queue_redraw()
@export var SOUTH_LIM = 0:
	set(new):
		SOUTH_LIM = new
		queue_redraw()
@export var EAST_LIM = 0:
	set(new):
			EAST_LIM = new
			queue_redraw()
@export var WEST_LIM = 0:
	set(new):
			WEST_LIM = new
			queue_redraw()

# ==== Window Compositing Variables ==== #
@onready var play_area:Rect2i = DisplayServer.screen_get_usable_rect()
var window_size:Vector2i
var BUFFER_SIZE = 2
var window_positions = [] # Hacky window position buffer to smooth rendering

# ==== Window and Camera Movement ==== #
var camera_disp # Camera displacement for window and camera position calculations
var pan_scale
var camera_offset = Vector2(0, 0)
var paused = false

# ==== Reference to Boat Node ==== #
@export_group("")
@export var boat:Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint():
		return
	
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_MAILBOX)
	
	# Scale Window size to based on monitor size and play area size.
	# Use the minimum value to ensure enough playable area
	var window_width = int(min(play_area.size.x/SIZE_WINDOWS.x, play_area.size.y/SIZE_WINDOWS.y))
	window_width -= window_width%RESOLUTION # Ensure window is a multiple of 64 pixels to keep pixel art compatible
	window_size = Vector2i(window_width, window_width)
	
	# Calculate playable area
	var play_size = Vector2i(SIZE_WINDOWS*window_width)
	play_area = Rect2i(play_area.get_center() - play_size/2 , play_size)
	
	# Calculate scaling for camera panning
	pan_scale = window_width/RESOLUTION
	
	# Calculate Desired mouse position in old viewport size
	var old_size = DisplayServer.window_get_size()
	var scaling = Vector2(window_width as float/old_size.x, window_width as float/old_size.y)
	var center_pos = scaling*RESOLUTION/2.0
	
	# Center Window and Mouse around Initial Player Location
	DisplayServer.window_set_position(play_area.get_center() + Vector2i(boat.global_position*pan_scale) - window_size/2)
	DisplayServer.window_set_size(window_size)
	get_viewport().warp_mouse(center_pos)
	
	# Signals for window and camera movement
	RenderingServer.connect("frame_pre_draw", self._update_camera_pos)
	RenderingServer.connect("frame_post_draw", self._update_window_pos)
	boat.connect("hook_move_notify", self._update_camera_offset)

func _draw():
	if not (Engine.is_editor_hint() and show_hint):
		return
	
	# Show window area on monitor
	var start = -SIZE_WINDOWS/2*RESOLUTION
	for x in SIZE_WINDOWS.x:
		for y in SIZE_WINDOWS.y:
			var rect = Rect2(start.x + RESOLUTION*x, start.y + RESOLUTION*y, RESOLUTION, RESOLUTION)
			draw_rect(rect, Color(Color.GRAY, 0.25), false)
	
	# Parallax Area
	var limits = Rect2(start*PARALLAX, Vector2(SIZE_WINDOWS*RESOLUTION*PARALLAX))
	draw_rect(limits, Color.HOT_PINK, false)
	
	# Parallax + Panning Area
	limits.position -= Vector2(WEST_LIM, NORTH_LIM)
	limits.end += Vector2(EAST_LIM + WEST_LIM, SOUTH_LIM + NORTH_LIM)
	draw_rect(limits, Color.LIME_GREEN, false)


func _process(delta):
	if Engine.is_editor_hint():
		return
		
	if Input.is_action_just_pressed("increase_camera_buffer"):
		BUFFER_SIZE += 1
		print(BUFFER_SIZE)
	elif Input.is_action_just_pressed("decrease_camera_buffer"):
		BUFFER_SIZE -= 1
		print(BUFFER_SIZE)
	
	if Input.is_action_pressed("esc"):
		$pause_bg.visible = true
		paused = true
		get_tree().paused = true
	elif Input.is_action_pressed("click"):
		if paused:
			get_viewport().warp_mouse(Vector2(RESOLUTION/2, RESOLUTION/2)) # Warp Mouse to Window Center
		$pause_bg.visible = false
		paused = false
		get_tree().paused = false

func _update_camera_offset(offset):
	camera_offset = offset.clamp(Vector2(-WEST_LIM, -NORTH_LIM), Vector2(EAST_LIM, SOUTH_LIM)).round()

func _update_camera_pos():
	if Engine.is_editor_hint():
		return
	
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
		#camera_offset = camera_offset.clamp(Vector2(-WEST_LIM, -NORTH_LIM), Vector2(EAST_LIM, SOUTH_LIM))
		#print(focus.global_position, ", ", camera_offset, ", min:", Vector2(-WEST_LIM, -NORTH_LIM),", max:", Vector2(EAST_LIM, SOUTH_LIM))
		position = Vector2i(camera_disp*PARALLAX + camera_offset)

func _update_window_pos():
	if Engine.is_editor_hint():
		return
	
	if not paused:	
		# ====== Set Window Position ====== #
		window_positions.push_back(play_area.get_center() + Vector2i(camera_disp*pan_scale) - window_size/2)
		while window_positions.size() > BUFFER_SIZE:
			DisplayServer.window_set_position(window_positions.pop_front())
