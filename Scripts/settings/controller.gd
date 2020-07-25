extends Node

var player = 1
var keys = []
var setting
export var key_path:PackedScene 
var key_hold = "keys/VBoxContainer"


func _apply_Settings():
	setting = get_parent().get_parent().Settings
	for i in setting.CONTROLLER.keys():
		for x in get_node(key_hold).get_children():
			if x.name == i:
				x.new_event(setting.CONTROLLER[i])
				break
	save_setting()


func save_setting():
	for x in get_node(key_hold).get_children():
		var temp = x.get_action()
		setting.CONTROLLER[temp[0]] = temp[1]

	get_parent().get_parent().Settings.CONTROLLER = setting.CONTROLLER


#		print(setting.CONTROLLER)
func _ready():
	setting = get_parent().get_parent().Settings
	for i in InputMap.get_actions():
		var z = {}
		if "ui" in i:
			continue
		for x in InputMap.get_action_list(i):
			if x is InputEventKey:
				z["key"] = x.scancode
			if x is InputEventJoypadButton:
				z["joybutton"] = x.button_index
			if x is InputEventJoypadMotion:
				z["joymotion"] = x.axis
		
		var init = key_path.instance()
		init.name = i
		if ! "P1" in i:
			init.hide()
		get_node(key_hold).add_child(init)
		init.new_event(z)
	_apply_Settings()


func pre_pressed():
	if player <= 1:
		player = 2
		$player/Label.text = "player" + str(player)
		_player_change()
		return
	player -= 1
	$player/Label.text = "player" + str(player)
	_player_change()


func next_pressed():
	if player >= 2:
		player = 1
		$player/Label.text = "player" + str(player)
		_player_change()
		return
	player += 1
	$player/Label.text = "player" + str(player)
	_player_change()


func _player_change():
	if player == 1:
		for i in get_node(key_hold).get_children():
			if ! "P1" in i.name:
				i.hide()
				continue
			i.show()
	if player == 2:
		for i in get_node(key_hold).get_children():
			if ! "P2" in i.name:
				i.hide()
				continue
			i.show()
