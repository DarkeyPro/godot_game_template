extends Node



var status:Array=[]
var label 
func _ready():
	label = Label.new()
	add_child(label)
	pass 


func add_status(status_name:String,object,status_ref:String,is_method:bool):
	status.append([status_name,object,status_ref,is_method])
func _process(delta):
	var text=""
	var fps = Engine.get_frames_per_second()
	text += str("FPS: ", fps)
	text += "\n"
	
	var mem = OS.get_static_memory_usage()
	text += str("Static Memory: ", String.humanize_size(mem))
	text += "\n"
	
	for i in status:
		var value = null
		if i[1] and weakref(i[1]).get_ref():
			if i[3]:
				value=i[1].call(i[2])
			else:
				value = i[1].get(i[2])
		text+=str(i[0],":",value)
	label.text=text
