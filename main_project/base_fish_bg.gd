extends Sprite2D
const velocity := 5
const delay := 0.8
var variance := randf_range(0, 0.5)
var curr_time = variance
var initPos = null

# Called when the node enters the scene tree for the first time.
func _ready():
	initPos = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position + Vector2(delta, 0) * (velocity + variance) * (1-2*int(flip_h))
	curr_time += delta
	if curr_time > delay:
		frame = 1 - frame
		curr_time = 0
		
	if abs(position[0] - initPos[0]) > 80:
		position = initPos
