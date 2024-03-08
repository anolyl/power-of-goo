extends Node2D

var speed = 1000

var retract

func setup(direction, lifeTime, speedIN):
	global_rotation = Vector2.RIGHT.angle_to(direction)
	$LifeTimer.wait_time = lifeTime
	self.speed = speedIN

func _ready():
	$NinePatchRect.rect_size.y = 40
	$NinePatchRect.rect_size.x = 0
	$Tentacle.position = Vector2.ZERO
	
	var collisionRectangle = RectangleShape2D.new()
	var collisionShape = CollisionShape2D.new()
	collisionShape.shape = collisionRectangle
	$Tentacle.add_child(collisionShape)
	collisionRectangle.extents = Vector2(0, 1)
	retract = false

func _physics_process(delta):
	if not retract:
		if $NinePatchRect.rect_size.x >= 1000:
			retract = true
		
		elif $Tentacle.get_overlapping_bodies().size() == 0:
			extend_and_shorten(delta)
	
	else:
		if not $NinePatchRect.rect_size.x <= 40:
			extend_and_shorten(- delta)
		else:
			queue_free()

func extend_and_shorten(delta):
	$NinePatchRect.rect_size.x += speed * delta
	$Tentacle.position.x = $NinePatchRect.rect_size.x / 2
	$Tentacle.get_child(0).shape.extents.x = $NinePatchRect.rect_size.x / 2


func _on_Tentacle_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(1, self, 2)
	
	elif body.is_class("TileMap") or body.is_class("StaticBody2D"):
		$LifeTimer.start()


func _on_LifeTimer_timeout():
	retract = true
	set_physics_process(true)
