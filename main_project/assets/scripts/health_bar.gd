@tool extends TextureProgressBar

@export_range(1,100,1, "or_greater") var max_health:int = 100:
	set(new_max):
		max_health = max(new_max, 1)
		resize_healthbar()
		
		
@export var current_health:int = 100:
	set(new_health):
		current_health = clamp(new_health, 0, max_health)
		resize_healthbar()
		pass

func resize_healthbar():
	const bar_start = 1.0
	var bar_end = self.size.x - 1
	var pixel_prog = round(lerp(bar_start, bar_end, current_health as float / max_health))
	
	# Always show at least 1 pixel of damage if not at max health
	pixel_prog = clamp(pixel_prog, bar_start + int(current_health > 0), bar_end + int(current_health < max_health))
	#if current_health < max_health:
	#	pixel_prog = min(pixel_prog, bar_end - 1)
		
	value = pixel_prog/self.size.x
	#queue_redraw()
	#print(self.size, ",", self.value, ",", current_health as float / max_health, ",", vis_percent)

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("resized", resize_healthbar)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
