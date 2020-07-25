extends Node
const type={arg_int="int",arg_string="string",arg_bool="bool",arg_float="float"}
const vaid_command = [["_output",[type.arg_string],"print in to the consloe"],["help",[],"list all function available"],["clean",[],"clean debug console"]]
var commands_path="res://Scripts/dev/commands/"

func _ready():
	for i in CustomTools.find_file(commands_path):
		var com=load(commands_path+i).new()
		add_child(com)
		com.name=i.split(".")[0]
		com.name=com.name.replace(" ","_")
		

	pass
func _output(value):
	print(value)
	return value
	
func set_speed(speed):
	speed = float(speed)
	return "Speed value must be between 1 and 5!"
	

func help():
	var help = ""
	var arg
	for i in vaid_command:
		if i[1].empty():
			arg="[empty]"
		else:
			arg=[]
			for x in i[1]:
				arg.append(x)
		help+=i[0]+":"+"\n"+"arg: "+str(arg)+"\n"+"discription"+":"+i[2]+"\n\n"
	for i in get_children():
		if i.command[1].empty():
			arg="[empty]"
		else:
			arg=[]
			for x in i.command[1]:
				arg.append(x)
		help+=i.command[0]+":"+"\n"+"arg: "+str(arg)+"\n"+"discription"+":"+i.command[2]+"\n\n"
	return help

func clean():
	get_parent().get_node("TextEdit").text="Debug Console\n"
	return ""

func run_command(function,arg):
	if get_node(function)!=null:
		if arg.size() != get_node(function).command[1].size():
			return str('failure executing command:"',get_node(function).command[0],'",expected',get_node(function).command[1].size(),'parameters')
		if !arg.empty():
			for x in range(get_node(function).command[1].size()):
				if not Console.check_type(arg[x],get_node(function).command[1][x]):
					
					return str('failure executing command:"',get_node(function).command[1][x],'",parameters',(x+1),'("',arg[x],'") is of the wrong type')
			return get_node(function).callv(function,arg)
			
		return get_node(function).call(function)
		
	else:
		return str('command:"',function,'",does not exist')
