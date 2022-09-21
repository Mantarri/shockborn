extends Viopa

class_name ViopaPlayer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		$SpringArm.rotation_degrees.x -= event.relative.y * mouseSensitivity
		$SpringArm.rotation_degrees.x = clamp($SpringArm.rotation_degrees.x, -90.0, 90.0)
		
		rotation_degrees.y -= event.relative.x * mouseSensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
