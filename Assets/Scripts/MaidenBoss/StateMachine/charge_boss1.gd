extends BaseStateBoss1

var chargeUpTimer = Timer.new()

var direction
var chargeStart

var hasFlashed

const GROUND_COLLISION_ON = 7
const GROUND_COLLISION_OFF = 6

var charging

var slimed

func _ready():
	add_child(chargeUpTimer)
	chargeUpTimer.wait_time = 3
	chargeUpTimer.one_shot = true
	
	chargeUpTimer.connect("timeout", self, "_on_chargeUpTimer_timeout")

func enter():
	charging = false
	slimed = false
	hasFlashed = false
	chargeStart = userEntity.get_chargeStart_location()
	chargeUpTimer.start()
	userEntity.emit_trail()
	userEntity.update_animation("delay")

func exit():
	pass

func process(_delta):
	return State.NULL

func physics_process(delta):
	
	if !hasFlashed and chargeUpTimer.time_left < .4:
		hasFlashed = true
		userEntity.flash()
	
	if not charging:
		
		#TODO: Convert to try_move_to_chargeStart_location() - move if condition into MaidenBoss script
		if (userEntity.global_position - chargeStart).length() > 50:
			userEntity.move_to_chargeStart_location()
	
	else:
		if userEntity.charge_and_collide(direction, delta):
			
			#TODO: Change method name to "on_hit_ground"
			userEntity.hit_ground()
			
			#TODO: *cease
			userEntity.seize_trail_emit()
			userEntity.change_collision(GROUND_COLLISION_OFF)
			userEntity.get_sprite().rotation = 0
			userEntity.update_animation("delay", true)
			userEntity.play_hitWall_sound()
			
			#TODO: change to "isVulnerable" variable located in MaidenBoss.gd
			if slimed:
				return State.STUNNED
			return State.DELAY
	
	return State.NULL

func _on_chargeUpTimer_timeout():
	direction = userEntity.global_position.direction_to(userEntity.get_target().global_position)
	
	#TODO: Try bitflags ( ex. 7 & ~1)
	userEntity.change_collision(GROUND_COLLISION_ON)
	
	var towardsTarget = userEntity.get_target().global_position - userEntity.global_position
	userEntity.get_sprite().rotation += Vector2.DOWN.angle_to(towardsTarget)
	
	charging = true
	userEntity.update_animation("charge")
	userEntity.emit_charge_particles()
	userEntity.play_scream_sound()

