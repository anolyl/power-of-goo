extends Node2D

var file 
var currentData = {
	"player": {
		"health": 4,
		"cranberries": 0,
		"currentCheckpoint": null,
		"currentScene": null,
	},

	"toBeDestroyed": [],
}

func save_game(dict):
#	print("savedgame called")
	file = File.new()
	file.open("user://savegame.save", File.WRITE)
	file.store_line(to_json(dict))
	file.close()

func load_game():
#	print("loadgame called")
	var file = File.new()
	if not file.file_exists("user://savegame.save"):
		save_game(currentData)
		return
	file.open("user://savegame.save", File.READ)
	currentData = parse_json(file.get_as_text())
	file.close()
	return currentData

func get_data():
	currentData = load_game()
	return currentData
