extends Spatial

var attackOwner : Viopa

func _ready():
	attackOwner = get_node("/root/Manager/Game/World/ViopaPlayer")

func shoot():
	var spaceState : PhysicsDirectSpaceState = attackOwner.get_world().direct_space_state
	var result : Dictionary = spaceState.intersect_ray(attackOwner.transform.origin, (attackOwner.transform.origin + Vector3.FORWARD.rotated(Vector3.UP, attackOwner.rotation.y)) * 8)
	if result.has("collider"):
		if result["collider"] is Viopa:
			var viopa : Viopa = result["collider"]
			viopa.hp -= 10
