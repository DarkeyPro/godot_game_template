extends Node

const User_directory = "user://"
const Res_directory = "res://DataBase/"
var Settings_Path: String = (
	Res_directory + "Settings.json"
	if ProjectSettings.get("GameInfo/debug")
	else User_directory + "Settings.json"
)


func _save_json(path, data):
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_line(to_json(data))
	file.close()


func _load_json(path):
	var file = File.new()
	if not file.file_exists(path):
		return ERR_FILE_NOT_FOUND
	file.open(path, File.READ)
	var data = parse_json(file.get_as_text())
	file.close()
	return data
