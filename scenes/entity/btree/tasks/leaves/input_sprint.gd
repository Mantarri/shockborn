extends TaskPlayer

# Attempt to sprint according to the `movement_*` InputEvents

class_name InputSprint

func run():
	if Input.is_action_pressed("movement_sprint"):
		player.addModifier(player.speedModifiers, "sprinting", 4.5, false)
		player.addModifier(player.jumpStrengthModifiers, "sprinting", 4.5, false)
		running()
	else:
		player.removeModifier(player.speedModifiers, "sprinting")
		player.removeModifier(player.jumpStrengthModifiers, "sprinting")
		success()
