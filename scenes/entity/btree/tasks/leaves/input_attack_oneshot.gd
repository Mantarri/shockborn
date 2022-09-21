extends TaskPlayer

class_name InputAttackOneshot

export(NodePath) var attackNode : NodePath

func run():
	var attack : Node = get_node(attackNode)
	if Input.is_action_just_pressed("action_special"):
		attack.shoot()
