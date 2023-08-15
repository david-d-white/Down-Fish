extends Node2D

# ====== Movement Constants ====== #
var BOAT_MAX_SPEED:float = 30:
	set(new_max):
		BOAT_MAX_SPEED = new_max
		BOAT_ACCEL = BOAT_MAX_SPEED/1
		WATER_DECEL = BOAT_MAX_SPEED/1.5
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
		change_depth_effect()
	elif Input.is_action_pressed("reel_up"):
		buffered_hook_pos -= hook_speed*delta
		buffered_hook_pos = max(HOOK_LIM, buffered_hook_pos)
		change_depth_effect()
		
	$hook_sprite.position.y = round(buffered_hook_pos)
	$line.points[1].y = $hook_sprite.position.y
	emit_signal("hook_move_notify", $hook_sprite.global_position)
	
	if $hook_sprite.position.y > HOOK_LIM:
		$hook_sprite.show()
		$Slingshot.hide()
	else:
		$hook_sprite.hide()
		$Slingshot.show()
		var new_money = 0
		for fish in caught_fish:
			new_money += fish.call("get_value")
			Globals.money += new_money
			hook_speed += fish.call("get_weight")
			fish.call("die")
		if new_money != 0:
			$money_notif.text = "+" + str(new_money) + "$"
			$money_notif.size.x = (len(str(new_money)) + 2) * 5
			$money_notif.visible = true
			notif_delay = NOTIF_DURATION
			if new_money >= 10:
				$sfx/big_fish_sold.play()
			else:
				$sfx/fish_sold.play()
		caught_fish = []


func _on_area_2d_body_entered(body:Node2D):
	if body.has_method("caught") and len(caught_fish) < hook_capacity:
		body.call("caught", $hook_sprite)
		$sfx/fish_pickup.play()
		hook_speed -= int(float(body.call("get_weight"))/hook_strength)
		caught_fish.append(body)

func change_depth_effect():
	print($hook_sprite.global_position.y)
	var index = AudioServer.get_bus_index("fishing_phase")
	var effect:AudioEffectLowPassFilter = AudioServer.get_bus_effect(index, 0)
	effect.cutoff_hz = 233716/($hook_sprite.global_position.y+175)-418
	print(effect.cutoff_hz)
