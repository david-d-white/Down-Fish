extends Node2D

# ====== Movement Constants ====== #
var BOAT_MAX_SPEED:float = 30
var BOAT_ACCEL:float = BOAT_MAX_SPEED/1
var WATER_DECEL:float = BOAT_MAX_SPEED/1.5

const HOOK_LIM:float = -4

# ====== text duration variables ====== #
const NOTIF_DURATION = 2.0
var notif_delay = 0.0

# ====== Positions and Speeds ====== #
@onready var buffered_boat_pos:float = position.x
@onready var buffered_hook_pos:float = $hook_sprite.position.y
var boat_speed:float = 0
var hook_speed:float = 10
var hook_strength:float = 1.0


# ====== hook catching variables ====== #
var hook_capacity = 1
var caught_fish = []
@onready var global_vars = get_node("/root/GlobalVars")

# ====== SIGNALS ====== #
signal hook_move_notify(newpos)

func _process(delta):
	WATER_DECEL = BOAT_ACCEL/1.5
	if notif_delay > 0.0:
		notif_delay -= delta
		if notif_delay <= 0.0:
			$money_notif.visible = false
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
		var new_money = 0
		for fish in caught_fish:
			new_money += fish.call("get_value")
			global_vars.money += new_money
			hook_speed += fish.call("get_weight")
			fish.call("die")
		if new_money != 0:
			$money_notif.text = "+" + str(new_money) + "$"
			$money_notif.size.x = (len(str(new_money)) + 2) * 5
			$money_notif.visible = true
			notif_delay = NOTIF_DURATION
		caught_fish = []


func _on_area_2d_body_entered(body:Node2D):
	if body.has_method("caught") and len(caught_fish) < hook_capacity:
		body.call("caught", $hook_sprite)
		hook_speed -= int(float(body.call("get_weight"))/hook_strength)
		caught_fish.append(body)
