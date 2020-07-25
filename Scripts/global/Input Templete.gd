extends Node
enum mode { pc, controller, phone }
func get_os():
	match OS.get_name():
		"Android":
			return mode.phone
		"iOS":
			return mode.phone
		"Windows":
			return mode.pc if ! check_controller() else mode.controller
		"OSX":
			return mode.pc if ! check_controller() else mode.controller
		"UWP":
			return mode.controller
		"X11":
			return mode.pc if ! check_controller() else mode.controller
		"HTML5":
			return mode.pc if ! check_controller() else mode.controller


enum game { single, multi }
var is2D: bool = false
var playerDead = false
var menu = {inventory = true, skill = false, quest = false}
var aim
var interact = false
var console_active = false
var HUD
var joystick = []
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
signal plus
# warning-ignore:unused_signal
signal dash
# warning-ignore:unused_signal
signal console
var B
var Y
var X
var A
var R
var RS
var L
var LS
var left_stick
var right_stick
var plus
var dash
var D_pad_right
var D_pad_left
var D_pad_up
var D_pad_down
var console


class action:
	var Cinput
	var onwer

	func _init(parent: Node, value: String):
		onwer = parent
		Cinput = value

	func action(value: int, object = null):
		match value:
			1:
				if Input.is_action_just_pressed(self.Cinput):
					if object == null:
						onwer.emit_signal(self.Cinput)
					else:
						onwer.emit_signal(self.Cinput, object)
			2:
				if Input.is_action_pressed(self.Cinput):
					if object == null:
						onwer.emit_signal(self.Cinput)
					else:
						onwer.emit_signal(self.Cinput, object)
			3:
				if Input.is_action_just_pressed(self.Cinput):
					onwer.emit_signal(self.Cinput, true)
				if Input.is_action_just_released(self.Cinput):
					onwer.emit_signal(self.Cinput, false)
			4:
				if Input.is_action_just_pressed(self.Cinput):
					onwer.emit_signal(self.Cinput)

			5:
				onwer.emit_signal(self.Cinput, Input.is_action_pressed(self.Cinput))

			6:
				(
					onwer.emit_signal(self.Cinput, object)
					if object != null
					else onwer.emit_signal(self.Cinput)
				)
			7:
				return Input.get_action_strength(self.Cinput)
			_:
				if Input.is_action_just_pressed(self.Cinput):
					if object == null:
						onwer.emit_signal(self.Cinput)
					else:
						onwer.emit_signal(self.Cinput, object)


func key_init():
	B = action.new(self, "B")
	Y = action.new(self, "Y")
	X = action.new(self, "X")
	A = action.new(self, "A")
	R = action.new(self, "R")
	RS = action.new(self, "RS")
	L = action.new(self, "L")
	LS = action.new(self, "LS")
	left_stick = action.new(self, "left_stick")
	right_stick = action.new(self, "right_stick")
	plus = action.new(self, "plus")
	dash = action.new(self, "dash")
	D_pad_right = action.new(self, "D_pad_right")
	D_pad_left = action.new(self, "D_pad_left")
	D_pad_up = action.new(self, "D_pad_up")
	D_pad_down = action.new(self, "D_pad_down")
	console = action.new(self, "console")


func _ready():
	key_init()
	self.pause_mode = Node.PAUSE_MODE_PROCESS
	connect("plus", self, "mission_pause")


func vibrate(strength, duration):
	if get_os() == mode.phone:
		Input.vibrate_handheld(duration * 1000)
	if get_os() == mode.pc:
		Input.start_joy_vibration(0, strength / 2, strength, duration)



func check_controller():
	for i in Input.get_connected_joypads():
		if Input.is_joy_known(i):
			var same = false
			for x in joystick:
				if x == i:
					same = true
					break
			if ! same:
				joystick.append(i)
	return


func _input(event):
	if playerDead:
		return
	if ! get_tree().paused and ! playerDead and ! interact:
		if get_os() == mode.pc:
			if get_tree().get_nodes_in_group("player"):
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			if event is InputEventMouseMotion:
				emit_signal("cameraMove", event.relative)
		if get_os() == mode.phone:
			if event.index == screen_joystick.onGoing_drag:
				if event is InputEventScreenDrag:
					emit_signal("cameraMove", event.relative)
	else:
		pass
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# warning-ignore:unused_argument
func _process(delta):
	console.action(4)
	plus.action(4)
	if playerDead or console_active or get_tree().paused or interact:
		return
	#movement
	if ! is2D:
		var move = Vector2(
			(
				Input.get_action_strength("left-stick right")
				- Input.get_action_strength("left-stick left")
			),
			(
				Input.get_action_strength("left-stick up")
				- Input.get_action_strength("left-stick down")
			)
		)
		emit_signal("movement", move)
	else:
		var move = Vector2(
			(
				Input.get_action_strength("left-stick right")
				- Input.get_action_strength("left-stick left")
			),
			0
		)
		emit_signal("movement", move)
#in mission UI
	D_pad_up.action(4)
	D_pad_down.action(4)
	#ABXY
	B.action(3)
	A.action(5)
	X.action(1)
	Y.action(1)
	#R,L,R2,L2
	R.action(5)
	RS.action(5)
	L.action(5)
	LS.action(1)
	#camera movement


#	if joystick.size() !=0 and!Vector2(Input.get_joy_axis(joystick,2),Input.get_joy_axis(joystick,3)).length() <=0.1:
#		var a=Vector2(Input.get_joy_axis(joystick,2),-Input.get_joy_axis(joystick,3))
#		emit_signal("cameraMove",a*30)


func mission_pause():
	if get_tree().paused:
		get_tree().paused = false
	else:
		get_tree().paused = true
