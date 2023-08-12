extends CharacterBody2D
const ATTR_DICT = {"manta_ray": [4, 26, 5, 10, 3, 2,true], "pufferfish": [3, 12, 3, 5, 2, 1, false], "small_fish": [3, 12, 0, 1, 1, 1, false], "eel": [2, 25, 15, 7, 2, 3, true], "angler": [5, 13, 25, 10, 5, 2, false]}
const MAX_TARGET_TIME = 3
var value = 1 # 
var SPEED = 1
var current_target:Vector2
var target_time = 0
var max_y = 30 # water level
var min_y = 100
var max_x = 0
var min_x = 100

#ATTR_DICT defines the behaviours of each individual fish. fish arrays are of the form:
# [collision_radius, collision_width, depth_weight, base_value, base_weight, base_speed, scared_of_hook]
# Called when the node enters the scene tree for the first time.
func _ready():
	choose_fish_type()
	current_target = see()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	target_time += delta
	if (position - current_target).length() < 8 or target_time > MAX_TARGET_TIME:
		current_target = see()
		target_time = 0
	move(current_target, SPEED * 32)
	#print_debug("target:", self.current_target, "position:", self.position)


func initialize(position:Vector2, spawn_size:Rect2, spawn_origin:Vector2):
	self.position = position
	self.max_y = -spawn_size.size.y + spawn_origin.y
	self.min_y = spawn_origin.y
	self.max_x = spawn_size.size.x + spawn_origin.x
	self.min_x = spawn_origin.x 


func move(target_value, speed):
	var direction = position.direction_to(target_value)
	velocity = direction*SPEED*32
	if direction.x < 0:
		$AnimatedSprite2D.flip_h = true
		$Area2D/CollisionPolygon2D.rotation = PI
	else:
		$AnimatedSprite2D.flip_h = false
		$Area2D/CollisionPolygon2D.rotation = 0
	move_and_slide()


func see():
	var potential_target = self.position + Vector2(randf_range(-30, 30), randf_range(-30, 30)) # look for food; get scared of hook
	potential_target.y = clamp(potential_target.y, max_y, min_y)
	potential_target.x = clamp(potential_target.x, min_x, max_x)
	print(potential_target)
	return potential_target

func caught():
	pass

func choose_fish_type(current_fish=""):
	if current_fish == "":
		var fish_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
		current_fish = fish_types[randi() % fish_types.size()]
		
	
	
	
	
	$AnimatedSprite2D.play(current_fish)
	var collision_shape = $CollisionShape2D.shape
	collision_shape.radius = ATTR_DICT[current_fish][0]
	collision_shape.height = ATTR_DICT[current_fish][1]
	return current_fish
