extends Sprite2D
signal move_camera_vert(amount)
var speed = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var old_position = position
	if Input.is_action_pressed("reel_down"):
		position[1] -= speed;
	if Input.is_action_pressed("reel_up"):
		position[1] += speed;
	move_camera_vert.emit(position[1] - old_position[1])
