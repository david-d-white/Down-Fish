extends Node2D

# ====== Movement Constants ====== #
const BOAT_MAX_SPEED:float = 30
const BOAT_ACCEL:float = BOAT_MAX_SPEED/1
const WATER_DECEL:float = BOAT_MAX_SPEED/1.5

const HOOK_LIM:float = -4

# ====== Positions and Speeds ====== #
@onready var buffered_boat_pos:float = position.x
@onready var buffered_hook_pos:float = $hook_sprite.position.y
var boat_speed:float = 0
var hook_speed:float = 10


# ====== hook catching variables ====== #
var hook_capacity = 1
var caught_fish = []
var money = 0

# ====== SIGNALS ====== #
signal hook_move_notify(newpos)

func _process(delta):
	# ====== Boat Controls and Rendering ====== #
	if Input.is_action_pressed("row_left"):
		$boat_sprite.flip_h = false
		$boat_sprite.play()
		boat_speed = move_toward(boat_speed, -BOAT_MAX_SPEED, BOAT_ACCEL*delta)
	elif Input.is_action_pressed("row_right"):
		$boat_sprite.flip_h = true
		$boat_sprite.play()
		boat_speed = move_toward(boat_speed, BOAT_MAX_SPEED, BOAT_ACCEL*delta)
	else:
		$boat_sprite.pause()
		$boat_sprite.set_frame_and_progress(0,0)
	
	boat_speed = move_toward(boat_speed, 0, WATER_DECEL*delta)
	
	# Align boat and adjust animation speed
	buffered_boat_pos += boat_speed*delta
	$boat_sprite.speed_scale = boat_speed/BOAT_MAX_SPEED
	position.x = round(buffered_boat_pos)
	
	# ====== Hook Controls and Rendering ====== #
	if Input.is_action_pressed("reel_down"):
		buffered_hook_pos += hook_speed*delta
	elif Input.is_action_pressed("reel_up"):
		buffered_hook_pos -= hook_speed*delta
		buffered_hook_pos = max(HOOK_LIM, buffered_hook_pos)
		
	$hook_sprite.position.y = round(buffered_hook_pos)
	$line.points[1].y = $hook_sprite.position.y
	emit_signal("hook_move_notify", $hook_sprite.global_position)
	
	if $hook_sprite.position.y > HOOK_LIM:
		$hook_sprite.show()
	else:
		$hook_sprite.hide()
		for fish in caught_fish:
			money += fish.call("get_value")
			hook_speed += fish.call("get_weight")
			fish.call("die")
		caught_fish = []


func _on_area_2d_body_entered(body:Node2D):
	if body.has_method("caught") and len(caught_fish) < hook_capacity:
		body.call("caught", $hook_sprite)
		hook_speed -= body.call("get_weight")
		caught_fish.append(body)
