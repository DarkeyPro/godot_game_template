extends Node

var is2D:bool = false
var playerDead = false
var menu ={inventory =true,skill = false,quest = false}
var aim
var interact =false
var console_active =false
var HUD 
var joystick
var screen_joystick

signal movement
signal cameraMove

# warning-ignore:unused_signal
signal RS
# warning-ignore:unused_signal
signal R
# warning-ignore:unused_signal
signal B
# warning-ignore:unused_signal
signal A 
# warning-ignore:unused_signal
signal X
# warning-ignore:unused_signal
signal Y
# warning-ignore:unused_signal
signal L
# warning-ignore:unused_signal
signal LS
# warning-ignore:unused_signal
signal right_stick
# warning-ignore:unused_signal
signal left_stick
# warning-ignore:unused_signal
signal D_pad_down
# warning-ignore:unused_signal
signal D_pad_up
# warning-ignore:unused_signal
signal D_pad_left
# warning-ignore:unused_signal
signal D_pad_right
# warning-ignore:unused_signal
signal console
var B =action.new(self,"B")
var Y =action.new(self,"Y")
var X =action.new(self,"X")
var A =action.new(self,"A")
var R =action.new(self,"R")
var RS =action.new(self,"RS")
var L =action.new(self,"L")
var LS =action.new(self,"LS")
var left_stick =action.new(self,"left_stick")
var right_stick =action.new(self,"right_stick")
var plus=action.new(self,"plus")
var dash =action.new(self,"dash")
var D_pad_right =action.new(self,"D_pad_right")
var D_pad_left =action.new(self,"D_pad_left")
var D_pad_up =action.new(self,"D_pad_up")
var D_pad_down =action.new(self,"D_pad_down")
var console =action.new(self,"console")
class action:
	var Cinput
	var onwer
	func _init(parent:Node,value:String):
		onwer=parent
		Cinput = value
	func action(value:int,object):
		match value:
			1:if Input.is_action_just_pressed(self.Cinput):
				if object == null:	
					onwer.emit_signal(self.Cinput)
				else:
					onwer.emit_signal(self.Cinput,object)
			2:if Input.is_action_pressed(self.Cinput):
				if object == null:	
					onwer.emit_signal(self.Cinput)
				else:
					onwer.emit_signal(self.Cinput,object)
			3:
				if Input.is_action_just_pressed(self.Cinput):
					onwer.emit_signal(self.Cinput,true)
				if Input.is_action_just_released(self.Cinput):
					onwer.emit_signal(self.Cinput,false)
			4:return Input.is_action_just_pressed(self.Cinput)
			5:if Input.is_action_just_pressed(self.Cinput):
				print(object)
				if object:
					object = false
				else:
					object= true
				onwer.emit_signal(self.Cinput,object)
			6:onwer.emit_signal(self.Cinput,Input.is_action_pressed(self.Cinput))
# warning-ignore:standalone_ternary
			7:onwer.emit_signal(self.Cinput,object) if object!=null else onwer.emit_signal(self.Cinput)
			8:return Input.get_action_strength(self.Cinput)
			_: if Input.is_action_just_pressed(self.Cinput):
				if object == null:	
					onwer.emit_signal(self.Cinput)
				else:
					onwer.emit_signal(self.Cinput,object)
		

	
func _ready():
	for i in Input.get_connected_joypads():
		if Input.is_joy_known(i):
			joystick = i
			break
	self.pause_mode = Node.PAUSE_MODE_PROCESS

	

func vibrate(strength,duration):
	var strength_v 
	if strength ==0:
		strength_v =0.3  
	elif strength ==1 :
		strength_v =0.6
	elif strength==2:
		strength_v = 1
	else:
		strength_v =0.5
	if asigned_os() =="phone": 
		Input.vibrate_handheld(duration*1000)
	if asigned_os() =="pc":
		Input.start_joy_vibration(0,strength_v/2,strength_v,duration)

func interaction(value:bool,visible:bool=true):
	if value:
		if visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	interact = value


func _input(event):
	if playerDead:
		return
	if !get_tree().paused and !playerDead and !interact:
		if asigned_os() =="pc":
			if get_tree().get_nodes_in_group("player"):
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			if event is InputEventMouseMotion:
				emit_signal("cameraMove",event.relative)
		if asigned_os() == "phone":
			if event.index == screen_joystick.onGoing_drag:
				if event is InputEventScreenDrag:
					emit_signal("cameraMove",event.relative)
	else:
		pass
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func asigned_os():
	if OS.get_name() == "Android" or OS.get_name() == "iOS" :
		return "phone"
	if OS.get_name() == "UWP" :
		return "console"
	if OS.get_name() == "X11" or OS.get_name() == "Windows" or OS.get_name() == "OSX" :
		return "pc"


# warning-ignore:unused_argument
func _process(delta):
	console_active= console.action(4)
	if playerDead or console_active:
		return

	#pause
	get_tree().paused =plus.action(4)
#in mission UI
	D_pad_up.action(5,menu.inventory)	
	D_pad_down.action(5,menu.quest)
	#ABXY
	B.action(3,null)
	A.action(6,null)
	X.action(1,null)
	Y.action(1,null)
	#R,L,R2,L2
	R.action(5,menu.skill)
	RS.action(6,null)
	L.action(1,null)
	LS.action(1,null)
	#camera movement
	if joystick !=null and!Vector2(Input.get_joy_axis(joystick,2),Input.get_joy_axis(joystick,3)).length() <=0.1:
		var a=Vector2(Input.get_joy_axis(joystick,2),-Input.get_joy_axis(joystick,3))
		emit_signal("cameraMove",a*30)
	#movement
	if !is2D :
		var move =Vector2(Input.get_action_strength("left-stick right")-Input.get_action_strength("left-stick left"),Input.get_action_strength("left-stick up")-Input.get_action_strength("left-stick down"))
		emit_signal("movement",move)
	else:
		var move =Vector2(Input.get_action_strength("left-stick right")-Input.get_action_strength("left-stick left"),0)
		emit_signal("movement",move)
