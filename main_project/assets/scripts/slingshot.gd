extends Node2D

const SLINGSHOT_COOLDOWN = 0.25
const SLINGSHOT_SPEED = 500
const SLINGSHOT_INDICATOR_LENGTH = 25
@export var ammo:PackedScene = null

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
		var shot:RigidBody2D = ammo.instantiate()
		shot.position = global_position
		shot.apply_impulse(dir*SLINGSHOT_SPEED)
		get_parent().get_parent().add_child(shot)
		$Cooldown.start(SLINGSHOT_COOLDOWN)
		pass
		
	#get_viewport().mouse
