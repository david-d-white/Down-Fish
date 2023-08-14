extends Node

@onready var base_music_wait = $fishing_music/play_music.wait_time
@onready var base_wind_wait = $fishing_music/play_wind.wait_time


const WIND_DB_CHANGE = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_music_timeout():
	$fishing_music/end_music.start(randf_range(60, 120))
	$fishing_music/piano.play()
	$fishing_music/wind.volume_db -= WIND_DB_CHANGE


func _on_end_music_timeout():
	$fishing_music/play_music.start(base_music_wait + randf_range(-100, 100))
	$fishing_music/piano.stop()
	$fishing_music/wind.volume_db += WIND_DB_CHANGE

func _on_play_wind_timeout():
	$fishing_music/end_wind.start(randf_range(30, 60))
	$fishing_music/wind.play()

func _on_end_wind_timeout():
	$fishing_music/play_wind.start(base_wind_wait + randf_range(-100, 100))
	$fishing_music/wind.stop()


