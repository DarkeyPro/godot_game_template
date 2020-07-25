extends Node

var setting
var quality := 0 setget set_quality
var environment = load(ProjectSettings.get("rendering/environment/default_environment"))
var shadow = 1 setget set_shadow


func _ready():
	setting = get_parent().get_parent().Settings
	update_setting()
	_apply_Settings()


func update_setting():
	if setting.Display.FullScreen and setting.Display.Borderless:
		$display_mode/OptionButton.select(0)
		$display_mode/OptionButton.get_popup()
		$resloution.hide()
	elif not setting.Display.FullScreen and not setting.Display.Borderless:
		$display_mode/OptionButton.select(1)
		$resloution/OptionButton.select(setting.Display.display_index)
		$resloution.show()
		$display_mode/OptionButton.get_popup()
		$resloution/OptionButton.get_popup()
	$vsync_hdr/vsync.pressed = setting.Display.Vsync
	$vsync_hdr/HDR.pressed = setting.Display.Hdr
	$fps/SpinBox.value = setting.Display.Fps
	$fps/HSplitContainer/Label2.text = str(setting.Display.Fps)
	$exposure/HSlider.value = setting.Display.Exposure
	$exposure/HSplitContainer/Label2.text = "0." + str(setting.Display.Exposure)
	$video_set/OptionButton.select(setting.Display.quality)
	$video_set/OptionButton.get_popup()
	$quality/anit_aliasing/OptionButton.select(setting.Display.AA)
	$quality/anit_aliasing/OptionButton.get_popup()
	$quality/shadow/OptionButton.select(int(str(setting.Display.Shadow_size).substr(0, 1)))
	$quality/shadow/OptionButton.get_popup()
	$quality/auto_exposure/OptionButton.pressed = setting.Display.auto_exposure
	$quality/post_process/OptionButton.select(setting.Display.post_process)
	$quality/post_process/OptionButton.get_popup()
	$quality/reflection/OptionButton.pressed = setting.Display.reflection
	$quality/gi/OptionButton.select(setting.Display.GI)
	$quality/gi/OptionButton.get_popup()


func display_mode_selected(index):
	match index:
		0:
			setting.Display.FullScreen = true
			setting.Display.Borderless = true
			$resloution.hide()
		1:
			setting.Display.FullScreen = false
			setting.Display.Borderless = false
			$resloution.show()


func _apply_Settings():
	resloution_selected(setting.Display.display_index)

	OS.window_fullscreen = setting.Display.FullScreen
	OS.window_borderless = setting.Display.Borderless
	OS.vsync_enabled = setting.Display.Vsync
	Engine.target_fps = setting.Display.Fps
	get_viewport().hdr = setting.Display.Hdr
	get_viewport().msaa = setting.Display.AA
	get_viewport().shadow_atlas_size = setting.Display.Shadow_size
	set_quality(setting.Display.quality)
	GI_selected(setting.Display.GI)
	post_process_selected(setting.Display.post_process)
	environment.set("tonemap_exposure", setting.Display.Exposure)
	environment.set("ss_reflections_enabled", setting.Display.reflection)
	environment.set("auto_exposure_enabled", setting.Display.auto_exposure)
	var String_spliter = $resloution/OptionButton.get_item_text(setting.Display.display_index)
	if setting.Display.display_index == 1:
		String_spliter = String_spliter.split("x")
		OS.window_size = Vector2(String_spliter[0], String_spliter[1])
	get_parent().get_parent().Settings.Display = setting.Display
	update_setting()


func set_quality(value):
	quality = value
	match quality:
		0:
			$quality.hide()
			get_viewport().msaa = 1
			environment.set("ss_reflections_enabled", false)
			environment.set("auto_exposure_enabled", false)
			post_process_selected(0)
		1:
			$quality.hide()
			get_viewport().msaa = 2
			environment.set("ss_reflections_enabled", true)
			environment.set("auto_exposure_enabled", false)
			post_process_selected(1)
		2:
			$quality.hide()
			get_viewport().msaa = 3
			environment.set("ss_reflections_enabled", true)
			environment.set("auto_exposure_enabled", true)
			post_process_selected(2)
		3:
			$quality.hide()
			get_viewport().msaa = 4
			environment.set("ss_reflections_enabled", true)
			environment.set("auto_exposure_enabled", true)
			post_process_selected(2)
		4:
			$quality.show()


func resloution_selected(index):
	if setting.Display.FullScreen and setting.Display.Borderless:
		return
	setting.Display.display_index = index


func Fps_changed(value):
	setting.Display.Fps = value
	$fps/HSplitContainer/Label2.text = str(value)


func vsync_pressed():
	setting.Display.Vsync = $vsync_hdr/vsync.pressed


func HDR_pressed():
	setting.Display.Hdr = $vsync_hdr/HDR.pressed


func video_quality_selected(index):
	set_quality(index)
	setting.Display.quality = index


func reflection_pressed():
	setting.Display.reflection = $quality/reflection/OptionButton.pressed


func auto_exposure_pressed():
	setting.Display.auto_exposure = $quality/auto_exposure/OptionButton.pressed


func set_shadow(value):
	setting.Display.Shadow_size = value * 1024


func shadow_size_selected(index):
	set_shadow(index)


func AA_selected(index):
	setting.Display.AA = index
	get_viewport().msaa = index


func post_process_selected(index):
	match index:
		0:
			environment.set("fog_enabled", false)
			environment.set("glow_enabled", false)
			environment.set("ssao_enabled", true)
			environment.set("ssao_quality", 0)
		1:
			environment.set("fog_enabled", true)
			environment.set("glow_enabled", true)
			environment.set("ssao_enabled", true)
			environment.set("ssao_quality", 1)
		2:
			environment.set("fog_enabled", true)
			environment.set("glow_enabled", true)
			environment.set("ssao_enabled", true)
			environment.set("ssao_quality", 2)
	setting.Display.post_process = index


func exposure_changed(value):
	setting.Display.Exposure = value
	$exposure/HSplitContainer/Label2.text = str(value)
	pass  # Replace with function body.


func GI_selected(index):
	setting.Display.GI = index
	pass  # Replace with function body.
