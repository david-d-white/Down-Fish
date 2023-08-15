@tool extends TextureProgressBar

@export_range(1,100,1, "or_greater") var max_health:int = 100:
	set(new_max):
		var health_loss = max_health - current_health
		max_health = max(new_max, 1)
		current_health = max_health - health_loss
		resize_healthbar()
		
@export var current_health:int = 100:
	set(new_health):
		current_health = clamp(new_health, 0, max_health)
		resize_healthbar()
		pass

signal health_empty

func change_health(delta):
	current_health = current_health + delta
	if current_health <= 0:
		emit_signal("health_empty")

func resize_healthbar():
	const bar_start = 1.0
	var bar_end = self.size.x - 1
	var pixel_prog = round(lerp(bar_start, bar_end, current_health as float / max_health))
	
	# Always show at least 1 pixel of damage if not at max health
	pixel_prog = clamp(pixel_prog, bar_start + int(current_health > 0), bar_end + int(current_health < max_health))		
	value = pixel_prog/self.size.x
