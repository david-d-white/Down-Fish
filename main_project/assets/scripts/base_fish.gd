extends CharacterBody2D
var ATTR_DICT = Globals.FISH_DICT
const MAX_TARGET_TIME = 3
var SPEED = 0.5
var current_target:Vector2
var target_time = 0
var max_y = 30 # water level
var min_y = 100
var max_x = 0
var min_x = 100
var fish_type = "small_fish"
var depth = 1
var hooked = false
var hook_node = null

#ATTR_DICT defines the behaviours of each individual fish. fish arrays are of the form:
# [collision_radius, collision_width, min_depth, spawn_weight, base_value, base_weight, base_speed, scared_of_hook]
# Called when the node enters the scene tree for the first time.
func _ready():
	#choose_fish_type()
	current_target = see()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	target_time += delta
	if (position - current_target).length() < 8 or target_time > MAX_TARGET_TIME:
		current_target = see()
		target_time = 0
	move(current_target, SPEED * 32)
	#print_debug("target:", self.current_target, "position:", self.position)


func initialize(position:Vector2, spawn_size:Rect2, spawn_origin:Vector2, depth=1, fish_name=""):
	self.position = position
	self.max_y = -spawn_size.size.y + spawn_origin.y
	self.min_y = spawn_origin.y
	self.max_x = spawn_size.size.x + spawn_origin.x
	self.min_x = spawn_origin.x
	self.depth = depth
	self.choose_fish_type(fish_name)


func move(target_value, speed):
	if hooked:
		global_position = hook_node.global_position + Vector2(0, ATTR_DICT[fish_type][1]/2)
		return
	var direction = position.direction_to(target_value)
	velocity = direction*SPEED*32*ATTR_DICT[fish_type][6] * depth
	if direction.x < 0:
		$AnimatedSprite2D.flip_h = true
		$Area2D/CollisionPolygon2D.rotation = PI
	else:
		$AnimatedSprite2D.flip_h = false
		$Area2D/CollisionPolygon2D.rotation = 0
	move_and_slide()


func see():
	var potential_target = self.position + Vector2(randf_range(-60, 60), randf_range(-30, 30)) # TODO: look for food; get scared of hook
	potential_target.y = clamp(potential_target.y, max_y, min_y)
	potential_target.x = clamp(potential_target.x, min_x, max_x)
	#print(potential_target)
	return potential_target

func caught(hook: Sprite2D):
	hooked = true
	hook_node = hook
	print(hook.global_position)
	$AnimatedSprite2D.flip_h = false
	self.rotation_degrees = -90
	self.set_collision_layer_value(1, false)


func get_weight():
	return ATTR_DICT[fish_type][5]

func get_value():
	return ATTR_DICT[fish_type][4]*(depth)

func die():
	get_tree().call_group("fish_spawner", "free_fish", depth)
	queue_free()
	

func choose_fish_type(current_fish=""):
	if current_fish == "":
		var fish_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
		current_fish = fish_types[randi() % fish_types.size()]
		
	
	
	
	
	$AnimatedSprite2D.play(current_fish)
	var collision_shape = $CollisionShape2D.shape
	collision_shape.radius = ATTR_DICT[current_fish][0]
	collision_shape.height = ATTR_DICT[current_fish][1]
	fish_type = current_fish
	return current_fish
