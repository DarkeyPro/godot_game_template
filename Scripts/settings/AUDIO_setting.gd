extends Node

var setting
var mute


func _ready():
	setting = get_parent().get_parent().Settings
	update_setting()
	_apply_Settings()


func update_setting():
	$VBoxContainer/Master/HS_G.value = setting.AUDIO.Master
	$VBoxContainer/BGM/HS_M.value = setting.AUDIO.BGM
	$VBoxContainer/SFX/HS_FX.value = setting.AUDIO.SFX
	$VBoxContainer/Voice_over/HS_FX.value = setting.AUDIO.VO
	$VBoxContainer/Voice_chat/HS_FX.value = setting.AUDIO.VC
	$mute.pressed = setting.AUDIO.MUTE
	$VBoxContainer/VoiceOver/OptionButton.select(setting.AUDIO.voice_over)
	$VBoxContainer/VoiceOver/OptionButton.get_popup()


func _apply_Settings():
	AudioServer.set_bus_volume_db(0, setting.AUDIO.Master)
	AudioServer.set_bus_volume_db(1, setting.AUDIO.BGM)
	AudioServer.set_bus_volume_db(2, setting.AUDIO.SFX)
	AudioServer.set_bus_volume_db(3, setting.AUDIO.VO)
	AudioServer.set_bus_volume_db(4, setting.AUDIO.VC)
	AudioServer.set_bus_mute(0, setting.AUDIO.MUTE)
	#voice over to translation todo
	get_parent().get_parent().Settings.AUDIO = setting.AUDIO
	pass


func master_value_changed(value):
	setting.AUDIO.Master = value
	pass  # Replace with function body.


func BGM_value_changed(value):
	setting.AUDIO.BGM = value
	pass  # Replace with function body.


func VO_value_changed(value):
	setting.AUDIO.VO = value
	pass  # Replace with function body.


func SFX_value_changed(value):
	setting.AUDIO.SFX = value
	pass  # Replace with function body.


func voice_chat_value_changed(value):
	setting.AUDIO.VC = value
	pass  # Replace with function body.


func _on_mute_toggled(button_pressed):
	setting.AUDIO.MUTE = button_pressed
	pass  # Replace with function body.


func voice_over_selected(value):
	setting.AUDIO.voice_over = value
	pass
