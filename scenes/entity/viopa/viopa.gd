extends Entity

class_name Viopa

export(float) var hp = 20.0
export(float) var currentHP

export(float) var speed = 7.0
export(Dictionary) var speedModifiers

export(float) var jumpStrength = 20.0
export(Dictionary) var jumpStrengthModifiers

export(float) var gravity = 50.0
export(Dictionary) var gravityModifiers

export(float) var mouseSensitivity = 0.05

var velocity : Vector3 = Vector3.ZERO
var snapVector : Vector3 = Vector3.DOWN

onready var springArm : SpringArm = $SpringArm
onready var model : Spatial = $BaseCharacter/CharacterArmature/Skeleton/Body

func _ready():
	var fileCheck : Directory = Directory.new()
	var saveFolder : String = "user://saves/" + Manager.saveName + "/"
	if fileCheck.file_exists(saveFolder + "save.tres"):
		entityData = load(saveFolder + "save.tres")
	else:
		entityData = load("res://scenes/entity/viopa/default_viopa_data.tres")
	entityData.moves[0] = load("res://scenes/entity/moves/normal/slash.tres")
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	if(velocity.x != 0 or velocity.z != 0 and !$BaseCharacter/AnimationPlayer.playback_active):
		if(entityData.speed + getModifierSum(speedModifiers) <= 7):
			$BaseCharacter/AnimationPlayer.play("Walk")
		else:
			$BaseCharacter/AnimationPlayer.play("Run")
	else:
		$BaseCharacter/AnimationPlayer.play("Idle")
	
	

func _physics_process(delta):
	var moveDir : Vector3 = Vector3.ZERO
	moveDir = transform.basis.x * (Input.get_action_strength("movement_right") - Input.get_action_strength("movement_left"))
	moveDir += transform.basis.z * (Input.get_action_strength("movement_backward") - Input.get_action_strength("movement_forward"))
	
	velocity.x = (moveDir.x * (entityData.speed + getModifierSum(speedModifiers)))
	velocity.z = (moveDir.z * (entityData.speed + getModifierSum(speedModifiers)))
	velocity.y -= gravity * delta
	
	moveDir.normalized()
	
	var justLanded : bool = is_on_floor() and snapVector == Vector3.ZERO
	var isJumping : bool = is_on_floor() and Input.is_action_just_pressed("movement_jump")
	
	if isJumping:
		velocity.y = jumpStrength + getModifierSum(jumpStrengthModifiers)
		snapVector = Vector3.ZERO
	elif justLanded:
		snapVector = Vector3.DOWN
	velocity = move_and_slide_with_snap(velocity, snapVector, Vector3.UP, true)
	
	#if Velocity.length() > 0.2:
	#	var lookDirection = Vector2(Velocity.z, Velocity.x)
	#	model.rotation.y = lookDirection.angle()

func _input(event):
	# Q By Default
	if event.is_action_pressed("action_unique"):
		pass
	# E By Default
	if event.is_action_pressed("action_special"):
		pass
	# LMB By Default
	if event.is_action_pressed("action_primary"):
		attack()
	# RMB By Default
	if event.is_action_pressed("action_secondary"):
		pass
	
	if(event.is_action_pressed("movement_sprint")):
		addModifier(speedModifiers, "sprinting", 5.5, false)
		addModifier(jumpStrengthModifiers, "sprinting", 5.5, false)
	elif(event.is_action_released("movement_sprint")):
		removeModifier(speedModifiers, "sprinting")
		removeModifier(jumpStrengthModifiers, "sprinting")

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		$SpringArm.rotation_degrees.x -= event.relative.y * mouseSensitivity
		$SpringArm.rotation_degrees.x = clamp($SpringArm.rotation_degrees.x, -90.0, 90.0)
		
		rotation_degrees.y -= event.relative.x * mouseSensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)

func getModifierSum(modifierDict : Dictionary) -> float:
	var sum : float
	for i in modifierDict:
		sum =+ modifierDict[i]
	return sum

func removeModifier(stat : Dictionary, modifier : String):
	stat.erase(modifier)

func addModifier(stat : Dictionary, modifier : String, value : float, canStack : bool):
	if(canStack):
		stat[modifier] = stat[modifier] + value
	else:
		stat[modifier] = value
