tool
extends Node
class_name State_Machine

export (NodePath)var skeleton_path
var skeleton
var state = null
var character
var states = []
var state_machine 
var animationTree
signal state_change

func _ready():
	character = get_parent()
	for i in get_children():
		if i is AnimationTree:
			animationTree = i
			break
	skeleton = get_node(skeleton_path)
	state_machine = animationTree.get("parameters/playback")

func _process(delta):
	if state != null:
		var transition = _get_transition(delta)
		if transition != null:
			_set_state(transition)
			if has_method(state):
				emit_signal("state_change")
				call(state,delta)
		else:
			print("no state has been asigned")

func set_init_anim(anime_id,wordIn_It=false):
	state = search(anime_id,wordIn_It)

func _get_transition(delta):
	return

func _set_state(new_state):
	state = new_state
	if new_state != null :
		_enter_state(new_state)

func _enter_state(new_state):
	for i in states:
		if i == new_state:
			play_state_machine_state(i)
			break

func play_state_machine_state(new_state):
	if new_state != null:
		emit_signal("state_change")
		state_machine.travel(new_state)

func _add_state(state_name):
	states.append(state_name)

func search(key,in_it= false):
	for i in states:
		if key == i and !in_it:
			return i
		elif key in i and in_it:
			return i

func _get_configuration_warning():
	var warrning = ""
	if state_machine == null:
		warrning = "Add an AnimeationTree node and set Tree Root to Ainmation Node State Machine"+"\n"+"Note: Dont rename the AnimationTree node\nAnd dont add states because there built in now"
	return warrning


func set_animation_property(property,value):
	animationTree[property]=value
