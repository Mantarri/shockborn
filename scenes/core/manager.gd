extends Node

var playerName : String

var saveName : String
var config : ConfigFile = ConfigFile.new()
var mainConfigPath : String = "user://config/main_settings.cfg"

var gamePackedScene : PackedScene = preload("res://scenes/game.tscn")
var menuManagerScene = preload("res://scenes/menus/menu_manager.tscn").instance()

onready var menuManager = get_node("MenuManager")
var game : Game

func _init():
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

		if not config.has_section_key("hud", "display_fps"):
			Manager.config.set_value("hud", "display_fps", true)
		
		if not config.has_section_key("hud", "display_position"):
			Manager.config.set_value("hud", "display_position", true)
	
		config.save(mainConfigPath)
	
	menuManager.load_menu(MenuManager.MENU.MAIN)

func load_game_scene():
	var gameScene : Game = gamePackedScene.instance()
	add_child(gameScene)

func unload_game():
	get_node("/root/Manager/Game").save()
	get_node("/root/Manager/Game").queue_free()

func get_entity_map(entity : Entity):
	var meshIntances : Array
	
	for i in entity.owner.get_node("NavigationMeshInstance").get_children():
		if i is NavigationMeshInstance:
			meshIntances.append(i)
	if meshIntances.size() > 0:
		return meshIntances[0].navmesh
	else:
		return null
