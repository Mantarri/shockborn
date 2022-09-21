extends TaskViopa

# Generic movement for Viopa

class_name MovementGenericViopa

export(float) var steerForce : float = 0.1
export(float) var lookDistance : float = 4
export(int) var rayCount : int = 8

var rayDirs : Array = []
var interest : Array = []
var dangers : Array = []

var chosenDir : Vector3 = Vector3.ZERO
var velocity : Vector3 = Vector3.ZERO
var acceleration : Vector3 = Vector3.ZERO
var counter : int = 0

func _ready():
	yield(owner.owner, "ready")
	interest.resize(rayCount)
	dangers.resize(rayCount)
	rayDirs.resize(rayCount)
	
	for i in rayCount:
		var angle : float = i * 2 * PI / rayCount
		var vec = Vector3.FORWARD.rotated(Vector3.UP, angle)
		#yield(owner.owner, "ready")
		vec.y = get_ray_y()
		
		rayDirs[i] = vec

func _physics_process(delta):
	if status == RUNNING:
		run_physics()
	else:
		viopa.velocity = Vector3.ZERO

func run():
	status = RUNNING

func run_physics():
	set_interest()
	set_dangers()
	choose_direction()
	
	viopa.velocity = Vector3.ZERO
	
	if !chosenDir == Vector3.ZERO:
		var desiredBasis : Basis = Transform.looking_at(chosenDir, Vector3.UP).basis
		viopa.transform.basis = viopa.transform.basis.slerp(desiredBasis, steerForce)
	
	viopa.velocity = viopa.velocity.linear_interpolate(chosenDir * (
		viopa.speed + viopa.getModifierSum(viopa.speedModifiers)), steerForce)
	
	#var desiredVel : Vector3 = chosenDir.rotated(Vector3.UP, get_rotation()) * (
	#	viopa.speed + viopa.getModifierSum(viopa.speedModifiers)
	#)
	
	#viopa.velocity = viopa.velocity.linear_interpolate(desiredVel, steerForce)
	
	
	#var firstPoint : Vector3 = get_ray_vec()
	#var secondPoint : Vector3 = get_ray_vec() * lookDistance
	#secondPoint.y = get_ray_y()
	#var result : Dictionary = viopa.get_world().direct_space_state.intersect_ray(firstPoint, secondPoint, [viopa])

func set_interest():
	#yield(owner.owner, "ready") 
	if owner and owner.has_method("get_path_direction"):
		var pathDirection = owner.get_path_direction(viopa.position)
		for i in rayCount:
			var dir : float = rayDirs[i].rotated(Vector3.UP, get_rotation()).dot(pathDirection)
			interest[i] = max(0, dir)
			
	# If there is no a world path, use default interest
	else:
		set_point_interest(get_node("/root/Manager/Game/World/ViopaPlayer").transform.origin)
		#set_default_interest()

func set_point_interest(pos : Vector3):
	# Move toward given point
	for i in rayCount:
		var dir : float = rayDirs[i].rotated(Vector3.UP, get_rotation()).dot(
			viopa.transform.origin.direction_to(pos))
		#print("1: " + str(rayDirs[i]))
		#print("2: " + str(rayDirs[i].rotated(Vector3.UP, get_rotation())))
		if get_rotation() > 0.0:
			print("3 " + str(get_rotation()))
		interest[i] = max(0, dir)

func set_default_interest():
	# Move forward by default
	for i in rayCount:
		var dir : float = rayDirs[i].rotated(Vector3.UP, get_rotation()).dot(
			-viopa.transform.basis.z)
		#print("1: " + str(rayDirs[i]))
		#print("2: " + str(rayDirs[i].rotated(Vector3.UP, get_rotation())))
		if get_rotation() > 0.0:
			print("3 " + str(get_rotation()))
		interest[i] = max(0, dir)

func set_dangers():
	var spaceState : PhysicsDirectSpaceState = viopa.get_world().direct_space_state
	for i in rayCount:
		var firstPoint : Vector3 = get_ray_vec()
		var secondPoint : Vector3 = get_ray_end_vec(rayDirs[i], lookDistance, get_rotation())
		secondPoint.y = get_ray_y()
		var result : Dictionary = spaceState.intersect_ray(firstPoint, secondPoint, [viopa])
		
		dangers[i] = 1.0 if result else 0.0

#func _get_dir(num : int):
#	#debug_rocket(get_ray_end(rayDirs[num]))
#	return get_ray_vec().direction_to(get_ray_end(rayDirs[num], lookDistance))

func choose_direction():
	# Remove interest from any cast detecting danger
	for i in rayCount:
		if dangers[i] > 0.0:
			interest[i] = 0.0
	chosenDir = Vector3.ZERO
	for i in rayCount:
		chosenDir += rayDirs[i] * interest[i]
	chosenDir.y = 0
	chosenDir = chosenDir.normalized()
	viopa.get_node("Label3D").text = str(chosenDir)

func get_ray_y() -> float:
	return viopa.transform.origin.y + 2.579

func get_ray_vec() -> Vector3:
	var vec = viopa.transform.origin
	vec.y = get_ray_y()
	return vec

func get_ray_end_vec(vec : Vector3, lengthMultiplier : float, rotation : float) -> Vector3:
	return get_ray_vec() + vec.rotated(Vector3.UP, rotation) * lengthMultiplier

func debug_rocket(pos : Vector3):
	if counter >= 10:
		var rocket : MeshInstance = load("res://scenes/entity/debug/debug_rocket.tscn").instance()
		rocket.transform.origin = pos
		viopa.owner.add_child(rocket)
		counter = 0
	else:
		counter += 1

func get_rotation():
	return deg2rad(0) #viopa.transform.basis.z.y #viopa.rotation.y

#func v2_to_v3(vector : Vector2, passedY : float) -> Vector3:
#	var result : Vector3 = Vector3.FORWARD.rotated(Vector3.UP, Vector2(vector.x, -vector.y).angle())
#	result.y = passedY
#	return result
