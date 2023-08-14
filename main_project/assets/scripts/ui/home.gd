extends Node2D

var oneshot = true
var leave_scene = false
const HOOK_SPEED = 32
const HOOK_LIM = -30
const VOLUME_FALLOFF = 30
@onready var real_position = $hook_bg.position
# Called when the node enters the scene tree for the first time.
func _ready():
#	var size = min(256, 128)
#	var screen_size = min(DisplayServer.screen_get_size()[0], DisplayServer.screen_get_size()[1])
#	var window_size = int((64 / float(size)) * screen_size)
#	oneshot = false
#	DisplayServer.window_set_size(Vector2i(int(window_size), int(window_size)))
#	DisplayServer.window_set_position(Vector2i(0,0))
#	print(window_size)
#	print(screen_size)
	pass
	
	#DisplayServer.window_set_size(Vector2i(int(window_size), int(window_size)))
	#DisplayServer.window_set_position(Vector2i(0,0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if oneshot:
		oneshot = false
		var RESOLUTION = 64
		var screen_rect = DisplayServer.screen_get_usable_rect()
		var window_size = screen_rect.size[screen_rect.size.min_axis_index()]
		window_size -= window_size%RESOLUTION
		window_size /= 2.0
		print(window_size)
		DisplayServer.window_set_size(Vector2i(window_size, window_size))
		DisplayServer.window_set_position(screen_rect.get_center() - Vector2i(window_size/2, window_size/2))
#
#
#		var size = min(256, 128)
##		var screen_size = min(DisplayServer.screen_get_size()[0], DisplayServer.screen_get_size()[1])
##		var window_size = int((64 / float(size)) * screen_size)
#		oneshot = false
#		DisplayServer.window_set_size(Vector2i(int(window_size), int(window_size)))
#		DisplayServer.window_set_position(Vector2i(0,0))
#		print(window_size)
#		print(screen_size)
	if leave_scene:
		real_position.y -= HOOK_SPEED * delta
		$bg_music.volume_db -= VOLUME_FALLOFF * delta
		$hook_bg.position = floor(real_position)
		if real_position.y < HOOK_LIM:
			get_tree().change_scene_to_file("res://assets/scenes/main.tscn")


func _on_texture_button_pressed():
	leave_scene = true
	$confirm_click.playing = true
	#$bg_music.playing = false
	
