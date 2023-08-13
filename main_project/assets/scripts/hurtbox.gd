extends Area2D

class_name Hurtbox

@export_flags ("Player", "Enemy", "Base") var LAYER = 0
@export var INVINCIBILITY_TIME:float = 0.5

signal damage_taken(hitbox)
signal invincibility_started()
signal invincibility_ended()

func set_invincible (invincible : bool):
	if invincible:
		$HurtboxShape.set_deferred("disabled", true)
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")
		$HurtboxShape.set_deferred("disabled", false)
	

func damage(hitbox):
	if $Invincibility.is_stopped():
		emit_signal ("damage_taken", hitbox)
		set_invincible (true)
		$Invincibility.start(INVINCIBILITY_TIME)

func _on_invincibility_ended():
	set_invincible (false)
