extends Node2D

export (float) var tonemapExposure
export (float) var tonemapWhite

export (float) var glowBloom
export (float) var glowIntensity
export (float) var glowStrength

export (float) var vignetteIntensity

export (bool) var editorTesting = false

func setEnvironmentVariables(mainScene):
	var worldEnvironment = mainScene.get_node("WorldEnvironment")
	var player = mainScene.get_player()

	if worldEnvironment:
		var environment = worldEnvironment.get_environment()
		environment.set_tonemap_exposure(tonemapExposure)
		environment.set_tonemap_white(tonemapWhite)

		environment.set_glow_intensity(glowIntensity)
		environment.set_glow_strength(glowStrength)
		environment.set_glow_bloom(glowBloom)

	if player:
		var HUD = player.get_node("HUD")
		if HUD:
			var effects = HUD.get_node("Effects")
			if effects:
				var vignette = effects.get_node("vignette")
				if vignette:
					vignette.modulate = Color(1, 1, 1, vignetteIntensity)

func _ready():
	var root = get_tree().get_root()
	var main = root.get_node("main")

	editorTesting = false # set it true in editor if needed

	setEnvironmentVariables(main)

var testChecker = 0
func _process(dt):
	testChecker += dt
	if testChecker > .05 and editorTesting:
		testChecker = 0

		var root = get_tree().get_root()
		var main = root.get_node("main")
		var worldEnvironment = main.get_node("WorldEnvironment")

		setEnvironmentVariables(main)
		
