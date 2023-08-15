@tool extends TextureButton

@export var upgrade_name:String:
	set(new_name):
		upgrade_name = new_name
		update_upgrade_name()
		
@export var prices:PackedInt64Array:
	set(new_prices):
		prices = new_prices
		update_upgrade_prices()

@export var purchased:int:
	set(new_purchased_count):
		purchased = clamp(new_purchased_count, 0, len(prices))
		update_upgrade_prices()

@export var values:PackedFloat64Array:
	set(new_values):
		values = new_values

@export var connected_node_name:String:
	set(new_node):
		connected_node_name = new_node

@export var connected_property:String:
	set(new_property):
		connected_property = new_property

signal property_update(node_name, property_name, value)

func update_upgrade_name():
	$UpgradeInfo/upgrade_label.text = upgrade_name
	$UpgradeInfo/upgrade_label.size.x = len(upgrade_name)*4
	#$UpgradeInfo/upgrade_price.position = $UpgradeInfo/upgrade_label.position + Vector2((len(upgrade_name) + 1)*4, 0)

func update_upgrade_prices():
	if $UpgradeInfo/upgrade_price == null:
		print("price not ready yet")
		return
	var text = ""
	if len(prices) == purchased:
		text = "SOLD"
	else:
		text = "$" + str(prices[purchased])
	$UpgradeInfo/upgrade_price.text = text
	$UpgradeInfo/upgrade_price.size.x = len(text)*4
	#print("setting price position for ", $UpgradeInfo/upgrade_label.text, " to ", 61 - len(text)*4)
	#$UpgradeInfo/upgrade_price.position.y = $UpgradeInfo/upgrade_price.position.y
	#$UpgradeInfo/upgrade_price.position.x = 64 - len(text)*4
	update_node()
	update_pips()

func update_pips():
	$UpgradeInfo/upgrade_pips/empty_pips.size.x = len(prices) * 5
	$UpgradeInfo/upgrade_pips/empty_pips/filled_pips.size.x = purchased * 5
	if purchased == 0:
		$UpgradeInfo/upgrade_pips/empty_pips/filled_pips.visible = false
	else:
		$UpgradeInfo/upgrade_pips/empty_pips/filled_pips.visible = true

func update_node():
	if len(values) > purchased:
		property_update.emit(connected_node_name, connected_property, values[purchased])

func _on_pressed():
	var money = Globals.money
	if purchased < len(prices) and money >= prices[purchased]:
		$purchase.play()
		Globals.money -= prices[purchased]
		purchased += 1
		update_upgrade_prices()
	else:
		$failed_purchase.play()

func _on_mouse_entered():
	$UpgradeInfo.visible = true

func _on_mouse_exited():
	$UpgradeInfo.visible = false
