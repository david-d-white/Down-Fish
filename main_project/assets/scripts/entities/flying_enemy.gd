extends CharacterBody2D

const SPEED = 32.0
const MAX_HEALTH = 10.0
const SOUND_DELAY = 3.0
var squak_time = 0

var inside_target = false

var target:Vector2

func initialize(position:Vector2, target:Vector2):
	$HealthBar.max_health = MAX_HEALTH
	$HealthBar.current_health = MAX_HEALTH
	self.target = target
	self.position = position

func _physics_process(delta):
	if squak_time > 0:
		squak_time -= delta
	var direction = position.direction_to(target)
	velocity = direction*SPEED
	if not inside_target:
		move_and_slide()
	$Animations.flip_h = velocity.x < 0

func _on_hurtbox_damage_taken(hitbox):
	$HealthBar.change_health(-hitbox.damage)

func _on_health_bar_health_empty():
	Globals.enemy_count -= 1
	if Globals.enemy_count == 0 and Globals.game_state == Globals.GAME_STATE.WAVE_CLEANUP:
		Globals.set_state(Globals.GAME_STATE.WAVE_COOLDOWN)
	queue_free()

func _on_hitbox_hit_success(hurtbox):
	inside_target = true
	$Animations.animation = "swoop"
	if squak_time <= 0:
		$squak.play()
		squak_time = SOUND_DELAY
	
