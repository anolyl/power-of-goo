extends Node2D

var file 
var defaultData = {
	"player": {
		"health": 4,
		"cranberries": 0,
		"currentCheckpoint": null,
		"currentScene": "FirstTutorial",
	},
	
	"slimesRescued": 0,
	"toBeDestroyed": {},
}
onready var currentData = defaultData
var destroyedEnemies = {}
var player 
var slimesRescued = 0

func save_game(dict):
	file = File.new()
	file.open("user://savegame.save", File.WRITE)
	file.store_line(to_json(dict))
	file.close()

func load_game():
	file = File.new()
	if not file.file_exists("user://savegame.save"):
		print("No savegame found, creating new one")
		save_game(defaultData)
		return
	file.open("user://savegame.save", File.READ)
	var loadedData = parse_json(file.get_as_text())
	currentData = loadedData
	destroyedEnemies = loadedData.toBeDestroyed

	return loadedData

func reset_data():
	save_game(defaultData)

func save_player(_player):
	player = _player
	save_game(get_data())

func append_to_be_destroyed(scene, object):
	destroyedEnemies[scene.name + '_' + object.name] = true

func addRescued():
	slimesRescued += 1

func get_data():
	return {
		"toBeDestroyed": destroyedEnemies,
		
		"slimesRescued": slimesRescued,
		"player": player.get_data()
	}
