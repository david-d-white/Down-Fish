extends NinePatchRect

#@onready var global_node = get_node("/root/GlobalVars")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Globals.game_state != Globals.GAME_STATE.WAVE_COOLDOWN:
		visible = false
		return
	var money = Globals.money
	$Current_money.text = "$:" + str(money)
	$Current_money.size.x = len($Current_money.text)*5
	if abs(get_tree().get_root().get_node("main/Island").global_position.x - get_tree().get_root().get_node("main/boat").global_position.x) < 15:
		visible = true
	else:
		visible = false


func _on_base_upgrade_property_update(node_name, property_name, value):
	get_tree().get_root().get_node("main/" + node_name).set(property_name, value)
