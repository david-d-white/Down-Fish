extends CharacterBody2D

const SPEED = 32.0
var target:Vector2

func initialize(position:Vector2, target:Vector2):
	self.target = target
	self.position = position
	print_debug("Flying Enemy Spawned at:", position)

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = position.direction_to(target)
	velocity = direction*SPEED
	move_and_slide()
	
	$Sprite.flip_h = velocity.x < 0
	
	#print_debug("target:", self.target, "position:", self.position)
