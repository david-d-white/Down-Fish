extends Marker2D

@export var fish_scene: PackedScene

const SPAWN_TIME:float = 0.0
var time_accum:float = SPAWN_TIME
var depth_capacities = [8, 12, 10]
var current_spawns = [0, 0, 0]
var spawn_bounds = null
var origin = null

@onready var depth_1_spawn_area:Rect2 = $depth_1/CollisionShape2D.shape.get_rect()
@onready var depth_1_origin:Vector2 = $depth_1.position
@onready var depth_2_spawn_area:Rect2 = $depth_2/CollisionShape2D.shape.get_rect()
@onready var depth_2_origin:Vector2 = $depth_2.position
@onready var depth_3_spawn_area:Rect2 = $depth_3/CollisionShape2D.shape.get_rect()
@onready var depth_3_origin:Vector2 = $depth_3.position

@onready var fish_arrs = [[],[],[]]

@onready var FISH_DICT = Globals.FISH_DICT

func _random_spawn(depth) -> Array:
	match depth:
		1:
			spawn_bounds = depth_1_spawn_area
			origin = depth_1_origin
		2:
			spawn_bounds = depth_2_spawn_area
			origin = depth_2_origin
		3:
			spawn_bounds = depth_3_spawn_area
			origin = depth_3_origin
	var spawn_x = randf_range(0, spawn_bounds.size.x)
	var spawn_y = randf_range(-spawn_bounds.size.y, 0)
		
	return [origin + Vector2(spawn_x, spawn_y), spawn_bounds]

# Called when the node enters the scene tree for the first time.
func free_fish(depth):
	current_spawns[depth-1] -= 1

# populates the array of possible fish based on the given depth.
func populate_pool(depth):
	for fish in FISH_DICT.keys():
		var fish_vals = FISH_DICT[fish]
		if fish_vals[2] <= depth:
			var num_fish = floor(fish_vals[3] / (4-fish_vals[2]))
			for i in range(num_fish):
				fish_arrs[depth-1].append(fish)
	print("depth:" + str(depth))
	print(fish_arrs[depth-1])
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_accum += delta
	if time_accum >= SPAWN_TIME:
		time_accum -= SPAWN_TIME
		var fish = fish_scene.instantiate()
		var depth = randi_range(1, 3)
		if current_spawns[depth-1] >= depth_capacities[depth-1]:
			return
		current_spawns[depth-1] += 1
		var spawn_poses = _random_spawn(depth)
		if len(fish_arrs[depth-1]) == 0:
			populate_pool(depth)
		fish_arrs[depth-1].shuffle()
		var fish_name = fish_arrs[depth-1].pop_front()
		print("spawning " + fish_name + " at depth " + str(depth))
		fish.choose_fish_type(fish_name)
		fish.initialize(spawn_poses[0], spawn_poses[1], origin, depth, fish_name)
		self.add_child(fish)


func _on_boat_hook_move_notify(newpos):
	pass # Replace with function body.
