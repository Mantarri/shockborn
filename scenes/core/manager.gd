extends Node

var playerName : String
var saveName : String
var config = ConfigFile.new()
var mainConfigPath : String = "user://config/main_settings.cfg"
var menuManagerScene = load("res://scenes/menus/menu_manager.tscn").instance()
onready var menuManager = get_node("MenuManager")
var game : Node

func _init():
	pass
	add_child(menuManagerScene)

func _ready():
	var userDataDir : Directory = Directory.new()
	
	if not userDataDir.open("user://saves") == OK:
		userDataDir.make_dir("user://saves/")
	
	if not userDataDir.open("user://config") == OK:
		userDataDir.make_dir("user://config/")
		config.save(mainConfigPath)
	
	var err = config.load(mainConfigPath)
	if err == OK: # If not, something went wrong with the file loading
		# Look for the display/width pair, and default to 1024 if missing
		var screenWidth = config.get_value("display", "width", 1024)
	
		if not config.has_section_key("audio", "mute"):
			config.set_value("audio", "mute", false)
	
		if not config.has_section_key("interface", "menu_transitions"):
			config.set_value("interface", "menu_transitions", true)
	
		config.save(mainConfigPath)
	
	menuManager.load_menu(MenuManager.MENU.MAIN)

func set_game_property(game_ : Node):
	game = game_

func unload_game():
	get_node("/root/Manager/Game").save()
	get_node("/root/Manager/Game").queue_free()
