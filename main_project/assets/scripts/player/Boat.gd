extends Sprite2D
var speed = 0.1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var old_position = position
	if Input.is_action_pressed("row_left"):
		position[0] -= speed;
	if Input.is_action_pressed("row_right"):
		position[0] += speed;
	get_parent().move_camera_horiz.emit(position[0] - old_position[0])
