extends TextureButton
const delay := 1.5
const move_offset := 1
var curr_time = 0
var has_risen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	curr_time += delta
	if curr_time > delay:
		if has_risen:
			position += Vector2(0, move_offset)
			has_risen = false
		else:
			position -= Vector2(0, move_offset)
			has_risen = true
		curr_time = 0
