extends TaskViopa

# Wander if no entity or drop detected

class_name WanderLegacy

export(NodePath) var visionCastPath
export(NodePath) var dropCastPath
export(NodePath) var soundsPath

onready var visionCast : RayCast = get_node(visionCastPath)
onready var dropCast : RayCast = get_node(dropCastPath)
onready var sounds : AudioStreamPlayer3D = get_node(soundsPath)
onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func _process(delta):
	if !dropCast.is_colliding():
		viopa.moveDir = Vector3.ZERO
		viopa.rotation_degrees.y += (-15 + rng.randi_range(12, -12))
		running()
	elif visionCast.is_colliding():
		if visionCast.get_collider() is ViopaPlayer && !sounds.is_playing():
			sounds.play()
		
		viopa.moveDir = Vector3.ZERO
		viopa.rotation_degrees.y += (-15 + rng.randi_range(12, -12))
		running()
	else:
		viopa.moveDir = (viopa.transform.basis.x * 0)
		
		viopa.moveDir += (viopa.transform.basis.z * -1.25)
		
		viopa.velocity.x = (viopa.moveDir.x * (viopa.speed + viopa.getModifierSum(viopa.speedModifiers)))
		
		viopa.velocity.z = (viopa.moveDir.z * (viopa.speed + viopa.getModifierSum(viopa.speedModifiers)))
		success()
