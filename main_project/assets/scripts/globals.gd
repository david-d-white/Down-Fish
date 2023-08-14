extends Node

const WAVE_TIMER_INIT = 60
const WAVE_COOLDOWN_INIT = 30

var money = 0
var waves = 0
var score = 0

enum GAME_STATE {TITLE, WAVE_COOLDOWN, WAVE, GAME_OVER} # Currently Unused, intended for replays
var game_state:GAME_STATE = GAME_STATE.TITLE

signal game_state_changed

func _ready():
	set_state(GAME_STATE.TITLE)

func set_state(new_state:GAME_STATE):
	self.game_state = new_state
	_stop_music()
	match new_state:
		GAME_STATE.TITLE:
			money = 0
			waves = 0
			score = 0
		GAME_STATE.WAVE_COOLDOWN:
			$wave_cooldown.start(WAVE_COOLDOWN_INIT)
			$LeaveHerJohnny.play(0)
			$Wind.play(0)
			$WindyWaves.play(0)
		GAME_STATE.WAVE:	
			$wave_timer.start(WAVE_TIMER_INIT + min(300, 15*waves))
			$DrunkenSailor.play(0)
		GAME_STATE.GAME_OVER:
			$wave_timer.stop()
			$wave_cooldown.stop()
	emit_signal("game_state_changed", self.game_state)

func _stop_music():
	$DrunkenSailor.stop()
	$LeaveHerJohnny.stop()
	$Shanty64.stop()
	$Wind.stop()
	$WindyWaves.stop()

func _on_wave_timer_timeout():
	waves += 1
	set_state(GAME_STATE.WAVE_COOLDOWN)

func _on_wave_cooldown_timeout():
	set_state(GAME_STATE.WAVE)
