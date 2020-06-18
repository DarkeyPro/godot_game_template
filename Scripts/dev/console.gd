extends Control

var command_handler
var load_command=load("res://Scripts/dev/command_handle.gd")
var history=[]
var line=history.size()
func _ready():
	command_handler=load_command.new()
	add_child(command_handler)
	grab_focus()
	InputTemplete.connect("console",self,"active")

func active():
	if !visible:
		visible =true
		$LineEdit.grab_focus()
		_process(true)
	else:
		visible =false
		_process(false)

func _process(delta):
	$LineEdit.grab_focus()

func output(value):
	$TextEdit.readonly=false
	$TextEdit.text =str($TextEdit.text,"\n",value)
	$TextEdit.set_v_scroll(9999999)
	$TextEdit.readonly=true

func _on_LineEdit_text_entered(new_text):
	$LineEdit.clear()
	process_command(new_text)
	line=history.size()

func process_command(text):
	var words = text.split(" ")
	words = Array(words)
	for i in range(words.count("")):
		words.erase("")
	if words.size()==0:
		return
	
	history.append(text)
	
	var command = words.pop_front()

	for i in command_handler.vaid_command:
		if i[0]==command:
			if words.size()!=i[1].size():
				output(str('failure executing command:"',command,'",expected',i[1].size(),'parameters'))
				return
			for x in range(words.size()):
				if not check_type(words[x],i[1][x]):
					output(str('failure executing command:"',command,'",parameters',(x+1),'("',words[x],'") is of the wrong type'))
					return
			output(command_handler.callv(command,words))
			return
	output(str('command:"',command,'",does not exist'))

func check_type(value,type):
	if type ==command_handler.arg_int:
		return value.is_value_integer()
	if type ==command_handler.arg_float:
		return value.is_value_float()
	if type ==command_handler.arg_bool:
		return (value=="true"or value =="false")
	if type ==command_handler.arg_string:
		return true
	return false

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.scancode == KEY_UP:
			goto_command_history(-1)
		if event.scancode == KEY_DOWN:
			goto_command_history(1)

func  goto_command_history(value):
	
	line += value
	line = clamp(line, 0, history.size())
	if line < history.size() and history.size() > 0:
		print(line,history[line],history)
		$LineEdit.text = str(history[line])
		$LineEdit.call_deferred("set_cursor_position", 99999999)
