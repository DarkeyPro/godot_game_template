extends Node

export var action: String = "quest"
var key = {}
var p_waiting_for_input = false
var s_waiting_for_input = false


func get_action():
	return [name, key]


func _input(event):
	if p_waiting_for_input:
		if event is InputEventKey:
			if InputMap.action_has_event(action, event):
				$ToolButton.text = OS.get_scancode_string(key["key"])
				$ToolButton.pressed = false
				p_waiting_for_input = false
				return
			InputMap.action_erase_events(action)
			key["key"] = event.scancode
			InputMap.action_add_event(action, event)
			if key.has("joybutton"):
				var new_event = InputEventJoypadButton.new()
				new_event.button_index = key["joybutton"]
				InputMap.action_add_event(action, new_event)
			$ToolButton.text = OS.get_scancode_string(key["key"])
			$ToolButton.pressed = false
			p_waiting_for_input = false
	if s_waiting_for_input:
		if event is InputEventJoypadButton:
			if InputMap.action_has_event(action, event):
				$ToolButton2.text = "button" + str(key["joybutton"])
				$ToolButton2.pressed = false
				s_waiting_for_input = false
				return
			InputMap.action_erase_events(action)
			key["joybutton"] = event.button_index
			if key.has("key"):
				var new_event = InputEventKey.new()
				new_event.scancode = key["key"]
				InputMap.action_add_event(action, new_event)
			InputMap.action_add_event(action, event)
			$ToolButton2.text = "button" + str(key["joybutton"])
			$ToolButton2.pressed = false
			s_waiting_for_input = false
		if event is InputEventJoypadMotion:
			if InputMap.action_has_event(action, event):
				$ToolButton2.text = "axis" + str(key["joymotion"])
				$ToolButton2.pressed = false
				s_waiting_for_input = false
				return
			InputMap.action_erase_events(action)
			key["joymotion"] = event.axis
			if key.has("key"):
				var new_event = InputEventKey.new()
				new_event.scancode = key["key"]
				InputMap.action_add_event(action, new_event)
			InputMap.action_add_event(action, event)
			$ToolButton2.text = "axis" + str(key["joymotion"])
			$ToolButton2.pressed = false
			s_waiting_for_input = false


func prime(button_pressed):
	if button_pressed:
		p_waiting_for_input = true
		$ToolButton.text = "Press Any Key"
	pass  # Replace with function body.


func scand(button_pressed):
	if button_pressed:
		s_waiting_for_input = true
		$ToolButton2.text = "Press Any Key"
	pass  # Replace with function body.


func new_event(value):
	InputMap.action_erase_events(name)
	get_node("Label").text = name
	if value.has("joybutton"):
		var event_joy_key = InputEventJoypadButton.new()
		event_joy_key.set_button_index(value["joybutton"])
		InputMap.action_add_event(name, event_joy_key)
		$ToolButton2.text = "button" + str(value["joybutton"])
		key["joybutton"] = value["joybutton"]
	if value.has("joymotion"):
		var event_joy_motion = InputEventJoypadMotion.new()
		event_joy_motion.axis = value["joymotion"]
		InputMap.action_add_event(name, event_joy_motion)
		$ToolButton2.text = "axis" + str(value["joymotion"])
		key["joymotion"] = value["joymotion"]
	if value.has("key"):
		var event_key = InputEventKey.new()
		event_key.set_scancode(value["key"])
		InputMap.action_add_event(name, event_key)
		$ToolButton.text = OS.get_scancode_string(value["key"])
		key["key"] = value["key"]
