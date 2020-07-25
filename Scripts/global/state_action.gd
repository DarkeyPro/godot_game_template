extends Node
class_name State

var state_machine


func _ready():
	if get_parent().is_in_group("state_machine"):
		state_machine = get_parent()
	pass


func _enter(msg := {}):
	pass


func _exit():
	pass
