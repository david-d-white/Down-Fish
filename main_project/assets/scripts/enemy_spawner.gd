extends Marker2D

@export var SPAWN_TIME:float = 5.0
var time_accum:float = SPAWN_TIME

@export var enemy_scene: PackedScene

@onready var spawn_area_min:Rect2 = $spawn_min/CollisionShape2D.shape.get_rect()
@onready var spawn_area_max:Rect2 = $spawn_max/CollisionShape2D.shape.get_rect()

@onready var global_vars = get_node("/root/GlobalVars")
@onready var is_enemy_mode = false

func _random_spawn() -> Vector2:
	var spawn_x = randf_range(-spawn_area_max.size.x/2, spawn_area_max.size.x/2)
	var spawn_y = randf_range(-spawn_area_max.size.y/2, spawn_area_max.size.y/2)
	return Vector2(spawn_x, spawn_y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	is_enemy_mode = global_vars.is_enemy_mode
	if not is_enemy_mode:
		return
	time_accum += delta
	if time_accum >= SPAWN_TIME:
		time_accum -= SPAWN_TIME
		var spawn_pos = _random_spawn()
		var enemy = enemy_scene.instantiate()
		enemy.initialize(spawn_pos, self.position)
		get_parent().add_child(enemy)
