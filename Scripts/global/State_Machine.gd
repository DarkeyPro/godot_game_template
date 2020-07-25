class_name State_Machine
extends Node

export var initial_state: NodePath
var state = null
var states = []
export var animationTree: NodePath
var state_machine: AnimationNodeStateMachinePlayback
var pre_state

signal state_change


func _init() -> void:
	add_to_group("state_machine")


func _ready():
	state_machine = get_node(animationTree)["parameters/playback"]
	connect("state_change", self, "state_changing")
	_add_states()
	set_init_state()


func state_changing(pre, current):
	pass


func _process(delta):
	state.call(state.name, delta)


func set_init_state():
	_enter_state(get_node(initial_state).name)


func _enter_state(new_state = "", msg = {}):
	if search(new_state) == null or state == get_node(new_state):
		return
	var next_state = search(new_state)
	if new_state == null:
		new_state = get_node(initial_state)
	if state != null:
		pre_state = state
		state._exit()
	state = next_state
	state._enter(msg)
	emit_signal("state_change", pre_state, state)


func play_state(value):
	state_machine.travel(value)


func _add_states():
	for i in get_children():
		if i is State:
			states.append(i)


func search(key):
	for i in states:
		if key == i.name:
			return i
	return null


func set_animation_property(property, value):
	get_node(animationTree)[property] = value
