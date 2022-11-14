extends MenuManager

func _ready():
	pass



func _on_Continue_pressed():
	pass # Replace with function body.


func _on_LoadGame_pressed():
	unload_menu(MENU.MAIN)
	load_menu(MENU.LOAD_GAME)
	Manager.saveName = $HBC/VBC/SaveName.text
	Manager.load_game_scene()


func _on_NewGame_pressed():
	load_menu(MENU.NEW_GAME)


func _on_QuickGame_pressed():
	unload_menu(MENU.MAIN)
	Manager.saveName = "Test"
	Manager.load_game_scene()


func _on_Credits_pressed():
	pass # Replace with function body.


func _on_Quit_pressed():
	get_tree().quit()
