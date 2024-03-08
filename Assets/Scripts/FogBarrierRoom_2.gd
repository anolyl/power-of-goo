extends StaticBody2D

export var speed = 150

var displayTexts = ["A dark force blocks your path. It seems something does not want you to leave.", "The path of escape presents itself before you. Yet you feel that something inside the cave still calls you.", "The path of escape presents itself before you. Your conscience is clear."]

func _ready():
	if UnlockedSkills.is_ability_unlocked("bossBeaten"):
		$CanvasLayer/Label.text = displayTexts[1]
		collision_layer = 0
		$Sprite.hide()
		$EvilLaugh.stream = null

func _process(delta):
	$Sprite.region_rect.position.x += speed * delta


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		$AnimationPlayer.play("textFadeInAndOut")
		$EvilLaugh.pitch_scale = rand_range(.75, 1.3)
		$EvilLaugh.play()
