extends Node

var master_volume: float
var music_volume : float
var sfx_volume : float

var currentResolution : Vector2 setget changeResolution

func _ready():
	master_volume = 5
	music_volume = 5
	sfx_volume = 5
	
	change_master_volume(master_volume)
	change_music_volume(music_volume)
	change_sfx_volume(sfx_volume)

func changeResolution(value):
	currentResolution = value
	get_viewport().set_size_override(true, currentResolution)

func change_master_volume(value):
	var masterIndex = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(masterIndex, value)
	master_volume = value
	
	if value == -30:
		AudioServer.set_bus_mute(masterIndex, true)
	else:
		AudioServer.set_bus_mute(masterIndex, false)

#TODO: Use Audioserver to change sound and music volume
func change_music_volume(value):
	
	var musicIndex = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(musicIndex, value)
	music_volume = value
	
	if value == -30:
		AudioServer.set_bus_mute(musicIndex, true)
	else:
		AudioServer.set_bus_mute(musicIndex, false)
#	music_volume = value
#	for node in get_tree().get_root().get_children():
#		if node.has_method("change_music_volume") and node != self:
#			node.change_music_volume(value)

func change_sfx_volume(value):
	var sfxIndex = AudioServer.get_bus_index("SFX")
	var reverbIndex = AudioServer.get_bus_index("ReverbSFX")
	AudioServer.set_bus_volume_db(sfxIndex, value)
	AudioServer.set_bus_volume_db(reverbIndex, value)
	
	sfx_volume = value
	
	if value == -30:
		AudioServer.set_bus_mute(sfxIndex, true)
		AudioServer.set_bus_mute(reverbIndex, true)
	else:
		AudioServer.set_bus_mute(sfxIndex, false)
		AudioServer.set_bus_mute(reverbIndex, false)
