extends Control

class_name MenuManager

var CurrentMenu
onready var TransitionTween : Tween = get_node("/root/Manager/MenuManager/Transition")
onready var MenuManager : Control = get_node("/root/Manager/MenuManager")

enum MENU {
	NONE,
	MAIN,
	NEW_GAME,
	LOAD_GAME,
	OPTIONS,
	PAUSE
}

var Menus : Dictionary = {
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
	TransitionTween.connect("tween_all_completed", MenuManager,
	"queue_free_unload_menu", [menu])

func queue_free_unload_menu(menu):
	MenuManager.get_node(MenuNames[menu]).queue_free()
	CurrentMenu = null
	TransitionTween.disconnect("tween_all_completed", MenuManager,
	"queue_free_unload_menu")

func load_menu(menu):
	call_deferred("_deferred_load_menu", menu)

func _deferred_load_menu(Menu):
	if MenuManager.get_children().size() > 1:
		disappear()
		TransitionTween.connect("tween_all_completed", MenuManager,
		"queue_free_menu", [MenuManager.get_children()[1], Menu])
	else:
			CurrentMenu = Menus[Menu]
			CurrentMenu = CurrentMenu.instance()
			CurrentMenu.rect_position.x = -OS.window_size.x
			MenuManager.add_child(CurrentMenu)
			appear(Menu)

func queue_free_menu(OldMenu, NewMenu):
	OldMenu.queue_free()
	CurrentMenu = Menus[NewMenu]
	CurrentMenu = CurrentMenu.instance()
	CurrentMenu.rect_position.x = -OS.window_size.x
	MenuManager.add_child(CurrentMenu)
	TransitionTween.disconnect("tween_all_completed", MenuManager,
	"queue_free_menu")
	appear(NewMenu)

func appear(Menu):
	var ScreenWidth : float = OS.window_size.x
	if Manager.config.get_value("interface", "menu_transitions") == true:
		TransitionTween.interpolate_property(MenuManager.get_node(MenuNames[Menu]),
		"rect_position:x",
		-1280, 0, 0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	
		TransitionTween.start()

func disappear():
	var ScreenWidth : float = OS.window_size.x
	if Manager.config.get_value("interface", "menu_transitions") == true:
		TransitionTween.interpolate_property(MenuManager.get_children()[1],
		"rect_position:x",
		0, -ScreenWidth, 0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	
		TransitionTween.start()
