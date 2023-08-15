extends NinePatchRect

#@onready var global_node = get_node("/root/GlobalVars")

var is_hidden = false

@onready var money_counter = $Current_money

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Globals.game_state != Globals.GAME_STATE.WAVE_COOLDOWN:
		visible = false
		return
	var money = Globals.money
	
	money_counter.text = "$" + str(money)
	money_counter.size.x = len(money_counter.text)*5
	if abs(get_tree().get_root().get_node("main/Island").global_position.x - get_tree().get_root().get_node("main/boat").global_position.x) < 15:
		if is_hidden:
			$AnimationPlayer.play("menu_open")
			is_hidden = false
			visible = true
	else:
		if not is_hidden:
			$AnimationPlayer.play("menu_close")
			is_hidden = true


func _on_base_upgrade_property_update(node_name, property_name, value):
	get_tree().get_root().get_node("main/" + node_name).set(property_name, value)
