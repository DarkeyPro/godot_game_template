extends Node
export var fade_duration:=3.0
var current_scene
var scene_loader:Thread
export (Array,PackedScene)var loading_element 
export var nofade:=false
var background:Panel
var fade:Panel
var tween:Tween
var input_manager
var data
func _ready():
	background = $background
	fade=$fade
	tween=$Tween
	scene_loader = Thread.new()
	input_manager=InputTemplete
	data=IndexDb
	load_element()
	pass


func _load(new_scene,continuing=false):
	var s = ResourceLoader.load(new_scene)
	var scene = s.instance()
	scene_loader.wait_to_finish()
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(scene)
	get_tree().current_scene = scene
	current_scene = get_tree().current_scene
	if continuing:
		load_data()
	if !nofade:
		background.hide()
		tween.interpolate_property(fade,"self_modulate",fade.self_modulate,Color(1,1,1,0),fade_duration)
		tween.start()
		yield(tween,"tween_completed")
		fade.hide()
		input_manager.can=true

func loading_scene(scene,continuing=false):
	if !nofade:	
		input_manager.can=false
		raise()
		fade.show()
		tween.interpolate_property(fade,"self_modulate",fade.self_modulate,Color(1,1,1,1),fade_duration)
		tween.start()
		yield(tween,"tween_completed")
		background.show()
	scene_loader.start(self,"_load",scene,continuing)



func load_data():

	pass
func load_element():
	for i in loading_element:
		var temp=i.instance()
		background.add_child(temp)
