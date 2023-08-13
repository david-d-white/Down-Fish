extends CharacterBody2D

const SPEED = 32.0
var target:Vector2

func initialize(position:Vector2, target:Vector2):
	self.target = target
	self.position = position

func _physics_process(delta):
	var direction = position.direction_to(target)
	velocity = direction*SPEED
	move_and_slide()
	$Sprite.flip_h = velocity.x < 0
