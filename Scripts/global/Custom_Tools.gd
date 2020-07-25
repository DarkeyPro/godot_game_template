extends Node
enum mode { pc, controller, phone }
func get_os():
	match OS.get_name():
		"Android":
			return mode.phone
		"iOS":
			return mode.phone
		"Windows":
			return mode.pc 
		"OSX":
			return mode.pc 
		"UWP":
			return mode.controller
		"X11":
			return mode.pc 
		"HTML5":
			return mode.pc 



func tweening(
	object: Node,
	property: String,
	to,
	duration = 0.0,
	completed = false,
	trans_type = Tween.TRANS_LINEAR,
	ease_type = Tween.EASE_IN_OUT,
	delay = 0.0
):
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(
		object, property, object.get(property), to, duration, trans_type, ease_type, delay
	)
	tween.start()
	if completed:
		yield(tween, "tween_completed")
	tween.queue_free()


func find_file(path, specific = "", type = ""):
	var indivisual = true if type != "" or specific != "" else false
	var paths = []
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		var first = file_name
		
		while file_name != "" and file_name != "." and file_name != "..":
			paths.append(file_name)
			file_name = dir.get_next()
			if first == file_name:
				break
	else:
		print("An error occurred when trying to access the path.")
	if indivisual:
		for i in paths:
			if specific in i or type in i:
				return i
		return ""
	else:
		return paths
