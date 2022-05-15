extends Node

var moves : Array
var types : Array
var dir : Directory = Directory.new()

func _ready():
	for i in self.get_children():
		i.add_to_group("Persist")
	
	add_to_group("Persist")
	
	if dir.open("res://types/") == OK:
		dir.list_dir_begin(true, true)
		var fileName = dir.get_next()
		while fileName != "":
			if not dir.current_is_dir():
				if fileName.get_extension() == "tres":
					types.append(load("res://types/" + fileName))
			fileName = dir.get_next()
	
	if dir.open("res://moves/") == OK:
		dir.list_dir_begin(true, true)
		var fileName = dir.get_next()
		while fileName != "":
			if not dir.current_is_dir():
				if fileName.get_extension() == "tres":
					moves.append(load("res://moves/" + fileName))
			fileName = dir.get_next()
	Manager.set_game_property(self)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		for i in Manager.menuManager.get_children():
			if(i.get_name() == "Pause"):
				return
		Manager.menuManager.load_menu(MenuManager.MENU.PAUSE)

func save():
	var saveNodes : Array = get_tree().get_nodes_in_group("Persist")
	
	var saveFile : File = File.new()
	
	for i in saveNodes:
		print(i)
	
	if saveFile.open("user://saves/" + Manager.saveName + ".dat", File.WRITE) == OK:
		print("user://saves/" + Manager.saveName + ".dat")
		for i in saveNodes:
			saveFile.store_var(i)
		saveFile.close()
	else:
		push_error("Could not save game file to: " + "user://saves/" + Manager.saveName + ". Check the folder's permissions and confirm that the file exists.")
