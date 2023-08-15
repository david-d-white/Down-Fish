extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.game_state_changed.connect(_on_game_state_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_hurtbox_damage_taken(hitbox:Hitbox):
	print("Base took ", hitbox.damage, " damage, HEALTH: ", $HealthBar.current_health)
	$HealthBar.change_health(-hitbox.damage)

func _on_health_bar_health_empty():
	print("Base fuckin died RIP")
	queue_free()

func _on_game_state_changed(game_state):
	if game_state == Globals.GAME_STATE.WAVE:
		$HealthBar.current_health = $HealthBar.max_health
