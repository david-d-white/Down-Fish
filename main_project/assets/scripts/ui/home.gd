extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var size = min(256, 128)
	var screen_size = min(DisplayServer.screen_get_size()[0], DisplayServer.screen_get_size()[1])
	var window_size = int((64 / float(size)) * screen_size)
	print(window_size)
	print(screen_size)
	
	DisplayServer.window_set_size(Vector2i(int(window_size), int(window_size)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://assets/scenes/main.tscn")
