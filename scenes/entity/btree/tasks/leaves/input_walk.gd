extends TaskPlayer

# Attempt to move horizontally acording to the `movement_*` InputEvents

class_name InputWalk

func run():
	# this line sets the move direction
	player.moveDir = (player.transform.basis.x *
	(Input.get_action_strength("movement_right") - Input.get_action_strength("movement_left")))
	
	# This line *ADDS* to the move direction's Z (forward-backward) axis
	player.moveDir += (player.transform.basis.z *
	(Input.get_action_strength("movement_backward") - Input.get_action_strength("movement_forward")))
	success()
	
	player.velocity.x = (player.moveDir.x * (
		player.speed + player.getModifierSum(player.speedModifiers)))
	
	player.velocity.z = (player.moveDir.z * (
		player.speed + player.getModifierSum(player.speedModifiers)))
