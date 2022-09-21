extends MovePhysical

class_name CannonBall

export(float) var gravity : float = 50.0

var velocity : Vector3 = Vector3.ZERO
var snapVector : Vector3 = Vector3.DOWN
var collision : KinematicCollision

func _ready():
	pass

func fire(vel : Vector3):
	self.velocity = vel

func _physics_process(delta):
	velocity = move_and_slide_with_snap(velocity, snapVector, Vector3.UP, true)
	if !is_on_floor():
		velocity.y -= gravity * delta
		return
		
	# Use this to handle explosions when hitting a player or NPC differently
	# collision = get_slide_collision(0)
	
	if get_slide_count() > 0:
		explode()

func explode():
	$Particles.emitting = true
