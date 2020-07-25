extends Node

var debug_overlay_path 
var command =["debug_overlay",[Console.command_handler.type.arg_bool],""]

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
