extends Node

var setting


func _ready():
	setting = get_parent().get_parent().Settings
	update_setting()

func _apply_Settings():
#	print(setting.GamePlay.language)
	if get_viewport().get_camera()!=null:
		get_viewport().get_camera().fov = setting.GamePlay.fov
	for i in get_tree().root.get_children():
		if i is Control and i.name =="UI" or i.name =="Ui"or i.name =="ui" or i.name =="uI":
			i.modulate.a=setting.GamePlay.hud_opacity
			break
	TranslationServer.set_locale(setting.GamePlay.language)
	get_parent().get_parent().Settings=setting 

func update_setting():
	$"HUD opacity/SpinBox".value = setting.GamePlay.hud_opacity
	$FOV/SpinBox.value = setting.GamePlay.fov
	for i in $language/OptionButton.get_item_count():
		if $language/OptionButton.get_item_text(i)==setting.GamePlay.language:
			$language/OptionButton.select(i)
			$language/OptionButton.get_popup()
			break
	_apply_Settings()
	


func fov_changed(value):
	$FOV/HSplitContainer/Label2.text = str(value)
	setting.GamePlay.fov = value
	

func hud_opacity_changed(value):
	$"HUD opacity/HSplitContainer/Label2".text = str(value)
	setting.GamePlay.hud_opacity = value



func language_selected(index):
	setting.GamePlay.language=$language/OptionButton.text
	pass # Replace with function body.
