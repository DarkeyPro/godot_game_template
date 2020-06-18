extends Node
var debug_overlay_path 

enum {arg_int,arg_string,arg_bool,arg_float}
const vaid_command = [["_output",[arg_string]],["debug_overlay",[arg_bool]]]

func load_object(object):
	print("hello")
	pass
func _output(value):
	print(value)
	return value
	
func set_speed(speed):
	speed = float(speed)
	return "Speed value must be between 1 and 5!"
	
func debug_overlay(value):
	if value=="false":
		value=""
	value= bool(value)
	if value:
		debug_overlay_path=load("res://Scripts/dev/debug_overlay.gd").new()
		add_child(debug_overlay_path)
		return "debug working"
	else:
		debug_overlay_path.queue_free()
		return "debug stoped working"
