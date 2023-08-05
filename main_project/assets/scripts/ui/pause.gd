extends ColorRect
var hasEscaped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_camera_2d_pause_open(current_position):
	position = current_position - Vector2(32, 32)
	visible = true


func _on_camera_2d_pause_close():
	visible = false
