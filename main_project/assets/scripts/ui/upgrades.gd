extends Control

@onready var global_node = get_node("/root/GlobalVars")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var money = global_node.money
	$Current_money.text = "$:" + str(money)
	$Current_money.size.x = len($Current_money.text)*5
	if Input.is_action_just_pressed("open_menu"):
		visible = not visible
	if visible and (self.global_position - get_tree().get_root().get_node("main/boat").global_position).length() > 200:
		visible = false


func _on_base_upgrade_property_update(node_name, property_name, value):
	get_tree().get_root().get_node("main/" + node_name).set(property_name, value)
