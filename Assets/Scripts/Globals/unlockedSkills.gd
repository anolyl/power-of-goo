extends Node

var skills = {}

var audioPlayer

func _ready():
	skills["doubleJump"] = false
	skills["strongPunch"] = false
	skills["puddle"] = false
	skills["hasKey"] = false
	skills["bossBeaten"] = false
	
	audioPlayer = AudioStreamPlayer.new()
	audioPlayer.volume_db = -20
	audioPlayer.stream = load("res://Assets/MusicAndSounds/Player/mixkit-magic-glitter-shot-2353.mp3")
	print(audioPlayer.stream.resource_name)
	audioPlayer.bus = "SFX"
	add_child(audioPlayer)

func unlock_ability(abilityName):
	skills[abilityName] = true
	audioPlayer.play()

func is_ability_unlocked(abilityName):
	return skills[abilityName]
