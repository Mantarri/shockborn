extends MenuManager

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_Resume_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	unload_menu(MENU.PAUSE)


func _on_Options_pressed():
	pass # Replace with function body.


func _on_ExitToMenu_pressed():
	Manager.unload_game()
	load_menu(MENU.MAIN)

func _input(event):
	if(event.is_action_pressed("ui_cancel")):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		unload_menu(MENU.PAUSE)


func _on_ExitToDesktop_pressed():
	get_tree().quit()
