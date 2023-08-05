extends Line2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_hook_move_camera_vert(amount):
	points[0] -= Vector2(0, amount)
