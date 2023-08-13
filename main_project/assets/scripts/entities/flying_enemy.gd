extends CharacterBody2D

const SPEED = 32.0
const MAX_HEALTH = 10.0

var target:Vector2

func initialize(position:Vector2, target:Vector2):
	$HealthBar.max_health = MAX_HEALTH
	$HealthBar.current_health = MAX_HEALTH
	self.target = target
	self.position = position

func _physics_process(delta):
	var direction = position.direction_to(target)
	velocity = direction*SPEED
	move_and_slide()
	$Animations.flip_h = velocity.x < 0
