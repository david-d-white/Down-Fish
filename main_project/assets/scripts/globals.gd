extends Node

const WAVE_TIMER_INIT = 30
const WAVE_COOLDOWN_INIT = 16
const WARNING_TIME = 15

var money = 0
var waves = 0
var score = 0

var enemy_count = 0

enum GAME_STATE {TITLE, WAVE_COOLDOWN, WAVE, WAVE_CLEANUP, GAME_OVER} # Currently Unused, intended for replays
var game_state:GAME_STATE = GAME_STATE.TITLE

const FISH_DICT = {"manta_ray": [4, 26, 2, 8, 10, 3, 2,true], 
				   "pufferfish": [3, 12, 1, 3, 5, 2, 1, false], 
				   "small_fish": [3, 12, 1, 30, 1, 0, 1, false], 
				   "eel": [2, 25, 2, 10, 7, 2, 3, true], 
				   "angler": [5, 13, 3, 3, 10, 5, 2, false],
				   "maddifish_1": [3, 12, 3, 1, 10, 1, 6, 1, true],
				   "maddifish_2": [3, 12, 3, 1, 15, 1, 8, 1, true],
					"jellyfish": [7, 14, 3, 10, 4, 0, 0.01, false],
					"sardine": [2, 15, 1, 10, 2, 0, 5, true],
					"greyfish": [3, 12, 1, 8, 3, 0, 3, false],
					"med_fish": [5, 27, 2, 5, 6, 5, 3, false],
					"clownfish": [6, 17, 1, 3, 8, 0, 4, true],
					"tangfish": [5, 23, 2, 6, 3, 3, 2, false]}
#FISH_DICT defines the behaviours of each individual fish. fish arrays are of the form:
# [collision_radius, collision_width, min_depth(1-3), rarity, (higher -> rarer), base_value, base_weight, base_speed, scared_of_hook]
# Called when the node enters the scene tree for the first time.


signal game_state_changed
signal wave_warning

func _ready():
	set_state(GAME_STATE.TITLE)

func set_state(new_state:GAME_STATE):
	self.game_state = new_state
	print(game_state)
	_stop_music()
	match new_state:
		GAME_STATE.TITLE:
			money = 0
			waves = 0
			score = 0
		GAME_STATE.WAVE_COOLDOWN:
			$wave_cooldown.start(WAVE_COOLDOWN_INIT)
			$wave_warning.start(WAVE_COOLDOWN_INIT-WARNING_TIME)
			$LeaveHerJohnny.play(0)
			$WindyWaves.play(0)
		GAME_STATE.WAVE:	
			$wave_timer.start(WAVE_TIMER_INIT + min(300, 15*waves))
			$DrunkenSailor.play(0)
		GAME_STATE.WAVE_CLEANUP:
			$wave_timer.stop()
			$wave_cooldown.stop()
			$DrunkenSailor.play(0)
		GAME_STATE.GAME_OVER:
			$wave_timer.stop()
			$wave_cooldown.stop()
	emit_signal("game_state_changed", self.game_state)

func _stop_music():
	$DrunkenSailor.stop()
	$LeaveHerJohnny.stop()
	$Shanty64.stop()
	$WindyWaves.stop()

func _on_wave_timer_timeout():
	waves += 1
	if enemy_count != 0:
		set_state(GAME_STATE.WAVE_CLEANUP)
	else:
		set_state(GAME_STATE.WAVE_COOLDOWN)

func _on_wave_cooldown_timeout():
	set_state(GAME_STATE.WAVE)

func _on_wave_warning_timeout():
	print("WAVE INCOMING!")
	wave_warning.emit()
