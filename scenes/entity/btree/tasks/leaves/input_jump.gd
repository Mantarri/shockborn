extends TaskPlayer

# Jump if jump action is pressed (parent function checks if player can jump in environment

class_name InputJump

func run():
	if Input.is_action_pressed("movement_jump"):
		player.jump()
		running()
	else:
		success()
