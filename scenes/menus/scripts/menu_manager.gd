extends Control

class_name MenuManager

var currentMenu
onready var transitionTween : Tween = get_node("/root/Manager/MenuManager/Transition")
onready var menuManager : Control = get_node("/root/Manager/MenuManager")

enum MENU {
	NONE,
	MAIN,
	NEW_GAME,
	LOAD_GAME,
	OPTIONS,
	PAUSE
}

var menus : Dictionary = {
	MENU.MAIN : load("res://scenes/menus/main_menu.tscn"),
	MENU.NEW_GAME : load("res://scenes/menus/new_game.tscn"),
	MENU.LOAD_GAME : load("res://scenes/menus/load_game.tscn"),
	MENU.OPTIONS : load("res://scenes/menus/options.tscn"),
	MENU.PAUSE : load("res://scenes/menus/pause.tscn")
}

var MenuNames : Dictionary = {
	MENU.MAIN : "MainMenu",
	MENU.NEW_GAME : "NewGame",
	MENU.LOAD_GAME : "LoadGame",
	MENU.OPTIONS : "Options",
	MENU.PAUSE : "Pause"
}

var MenuPaths : Dictionary = {
	MENU.MAIN : "/root/Manager/MenuManager/MainMenu",
	MENU.NEW_GAME : "/root/Manager/MenuManager/NewGame",
	MENU.LOAD_GAME : "/root/Manager/MenuManager/LoadGame",
	MENU.OPTIONS : "/root/Manager/MenuManager/Options",
	MENU.PAUSE : "/root/Manager/MenuManager/Pause"
}



func _ready():
	pass


func unload_menu(menu):
	call_deferred("_deferred_unload_menu", menu)

func _deferred_unload_menu(menu):
	disappear()
	transitionTween.connect("tween_all_completed", menuManager,
	"queue_free_unload_menu", [menu])

func queue_free_unload_menu(menu):
	menuManager.get_node(MenuNames[menu]).queue_free()
	currentMenu = null
	transitionTween.disconnect("tween_all_completed", menuManager,
	"queue_free_unload_menu")

func load_menu(menu):
	call_deferred("_deferred_load_menu", menu)

func _deferred_load_menu(menu):
	if menuManager.get_children().size() > 1:
		disappear()
		transitionTween.connect("tween_all_completed", menuManager,
		"queue_free_menu", [menuManager.get_children()[1], menu])
	else:
			currentMenu = menus[menu]
			currentMenu = currentMenu.instance()
			currentMenu.rect_position.x = -OS.window_size.x
			menuManager.add_child(currentMenu)
			appear(menu)

func queue_free_menu(oldMenu, newMenu):
	oldMenu.queue_free()
	currentMenu = menus[newMenu]
	currentMenu = currentMenu.instance()
	currentMenu.rect_position.x = -OS.window_size.x
	menuManager.add_child(currentMenu)
	transitionTween.disconnect("tween_all_completed", menuManager,
	"queue_free_menu")
	appear(newMenu)

func appear(menu):
	var screenWidth : float = OS.window_size.x
	if Manager.config.get_value("interface", "menu_transitions") == true:
		transitionTween.interpolate_property(menuManager.get_node(MenuNames[menu]),
		"rect_position:x",
		-1280, 0, 0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	
		transitionTween.start()

func disappear():
	var screenWidth : float = OS.window_size.x
	if Manager.config.get_value("interface", "menu_transitions") == true:
		transitionTween.interpolate_property(menuManager.get_children()[1],
		"rect_position:x",
		0, -screenWidth, 0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	
		transitionTween.start()
