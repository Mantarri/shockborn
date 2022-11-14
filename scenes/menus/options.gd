extends MenuManager

func _ready():
	$HBoxContainer/VBoxContainer/DisplayFPS.toggle_mode = Manager.config.get_value("hud", "display_fps")
	$HBoxContainer/VBoxContainer/DisplayPosition.toggle_mode = Manager.config.get_value("hud", "display_position")

func _input(event):
	if(event.is_action_pressed("ui_cancel")):
		load_menu(MENU.PAUSE)

func _on_Exit_pressed():
	load_menu(MENU.PAUSE)


func _on_DisplayFPS_toggled(button_pressed):
	Manager.config.set_value("hud", "display_fps", button_pressed)


func _on_DisplayPosition_toggled(button_pressed):
	Manager.config.set_value("hud", "display_position", button_pressed)
