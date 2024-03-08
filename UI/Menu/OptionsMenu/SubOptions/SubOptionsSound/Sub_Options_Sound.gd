extends Control

onready var masterSlider = $Sub_Options_Sound_Buttons/MasterVolumeMarginContainer/MasterVolumeHBoxContainer/Master_Volume_Slider_Container/MasterMarginContainer/MasterVolumeSlider
onready var musicSlider = $Sub_Options_Sound_Buttons/MusicVolumeMarginContainer/MusicHBoxContainer/MusicVolumeSliderContainer/MusicMarginContainer/MusicVolumeSlider
onready var sfxSlider = $Sub_Options_Sound_Buttons/SFXMarginContainer/SFXHBoxContainer/SFXVolumeSliderContainer/SFXMarginContainer/SFXVolumeSlider

func _ready():
	rect_size = settings.currentResolution
	musicSlider.value = settings.music_volume 
	masterSlider.value = settings.master_volume 
	sfxSlider.value = settings.sfx_volume

func _on_MusicVolumeSlider_value_changed(value):
	settings.change_music_volume(value)


func _on_MasterVolumeSlider_value_changed(value):
	settings.change_master_volume(value)


func _on_SFXVolumeSlider_value_changed(value):
	settings.change_sfx_volume(value)
