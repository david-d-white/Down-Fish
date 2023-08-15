extends Marker2D

@export var SPAWN_TIME:float = 5.0
var time_accum:float = SPAWN_TIME

@export var enemy_scene: PackedScene

@onready var spawn_area_min:Rect2 = $spawn_min/CollisionShape2D.shape.get_rect()
@onready var spawn_area_max:Rect2 = $spawn_max/CollisionShape2D.shape.get_rect()

func _ready():
	Globals.connect("game_state_changed", _on_game_state_changed)

func _random_spawn() -> Vector2:
	var spawn_x = randf_range(-spawn_area_max.size.x/2, spawn_area_max.size.x/2)
	var spawn_y = randf_range(-spawn_area_max.size.y/2, spawn_area_max.size.y/2)
	return Vector2(spawn_x, spawn_y)
	
func _on_game_state_changed(state):
	match state:
		Globals.GAME_STATE.WAVE:
			$Spawn_timer.start(SPAWN_TIME/min(10, 1+floor(Globals.waves/3)))
		_:
			$Spawn_timer.stop()
	
func _on_spawn_timer_timeout():
	if Globals.game_state != Globals.GAME_STATE.WAVE:
		return
	
	var spawn_pos = _random_spawn()
	var enemy = enemy_scene.instantiate()
	enemy.initialize(spawn_pos, self.position)
	get_parent().add_child(enemy)
	Globals.enemy_count += 1
	pass # Replace with function body.
