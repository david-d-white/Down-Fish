extends Node2D

const SLINGSHOT_COOLDOWN = 0.25
var SLINGSHOT_SPEED = 500
const SLINGSHOT_INDICATOR_LENGTH = 25
const SHOT_SPREAD = PI/16 # used when there are more than one projectile.
@export var ammo:PackedScene = null
var damage = 5
var projectiles = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pos_2 = get_global_mouse_position() - global_position
	var dir = pos_2 - $Line2D.points[0]
	dir = dir.normalized()
	
	pos_2 = pos_2.limit_length(SLINGSHOT_INDICATOR_LENGTH)
	
	$Line2D.points[1] = pos_2
	$Target.position = pos_2
	
	if Input.is_action_just_pressed("fire") && $Cooldown.is_stopped():
		print("Firing")
		$shoot_sound.play()
		var angle = 0.0
		for projectile in range(projectiles):
			var shot:RigidBody2D = ammo.instantiate()
			shot.position = global_position
			shot.get_node("Hitbox").set("damage", damage)
			shot.apply_impulse((dir.rotated(angle))*SLINGSHOT_SPEED)
			get_parent().get_parent().add_child(shot)
			angle += SHOT_SPREAD
		
		$Cooldown.start(SLINGSHOT_COOLDOWN)
		pass
		
	#get_viewport().mouse
