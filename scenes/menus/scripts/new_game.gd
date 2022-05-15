extends MenuManager



func _ready():
	$HBC/VBC/SaveName.grab_focus()



func _on_CreateWorld_pressed():
	unload_menu(MENU.NEW_GAME)
	Manager.saveName = $HBC/VBC/SaveName.text
	var gameScene : PackedScene = load("res://scenes/game.tscn")
	var gameSceneNode = gameScene.instance()
	Manager.add_child(gameSceneNode)
	


func _on_Cancel_pressed():
	load_menu(MENU.MAIN)


func _on_SaveName_text_changed(NewText : String):
	if not NewText.empty():
		$HBC/VBC/CreateWorld.disabled = false
	else:
		$HBC/VBC/CreateWorld.disabled = true
