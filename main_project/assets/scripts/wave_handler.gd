extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_attack_scene_timeout():
	Globals.is_enemy_mode = true
	$end_attack_scene.start(60 + min(300, 15*Globals.waves))


func _on_end_attack_scene_timeout():
	Globals.is_enemy_mode = false
	Globals.waves += 1
	$start_attack_scene.start()
