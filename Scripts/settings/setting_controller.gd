extends Control

var Settings = {
	"GamePlay": {"language":"en_US","fov": 70, "hud_opacity": 1},
	"Display":
	{
		"display_index": 0,
		"Fps": 30,
		"Hdr": false,
		"quality": 0,
		"Exposure": 5,
		"AA": 0,
		"reflection": false,
		"post_process": 0,
		"GI": 0,
		"auto_exposure": false,
		"Shadow_size": 1024,
		"FullScreen": false,
		"Borderless": false,
		"Vsync": true
	},
	"AUDIO":
	{"voice_over": 0, "MUTE": false, "Master": 100, "BGM": 100, "SFX": 100, "VO": 100, "VC": 100},
	"CONTROLLER": {}
}


func _init():
	Settings = IndexDb._load_json(IndexDb.Settings_Path)


func _on_Button_pressed():
	IndexDb._save_json(IndexDb.Settings_Path, Settings)
	for i in get_node("MarginContainer").get_children():
		print(i)
		i._apply_Settings()

func _on_CLOSE_pressed():
	hide()
	pass
func game_play_show():
	for i in get_node("MarginContainer").get_children():
		if !i.name =="game_play":
			i.hide()
		else:
			i.show()
	pass
func controller_show():
	for i in get_node("MarginContainer").get_children():
		if !i.name =="controller":
			i.hide()
		else:
			i.show()
func VEDIO_show():
	for i in get_node("MarginContainer").get_children():
		if !i.name =="VEDIO_PAN":
			i.hide()
		else:
			i.show()
func AUDIO_show():
	for i in get_node("MarginContainer").get_children():
		if !i.name =="AUDIO_PAN":
			i.hide()
		else:
			i.show()
