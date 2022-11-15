extends Node

class_name Game

var resources : Dictionary = {
	"moves": {},
	"sensors": {},
	"entities": {}
}

var moves : Dictionary
var coreMovesDir : String = "res://scenes/moves/"

var types : Array
var coreTypesDir : String = "res://scenes/types/"

var entities : Dictionary
var coreEntitiesDir : String = "res://scenes/entities"

var coreSensorsDir : String = "res://scenes/sensors/"

var hud : Control = preload("res://scenes/ui/hud.tscn").instance()
var worlds : Array = [
	preload("res://scenes/worlds/world.tscn")
]

func _ready():
	Manager.game = Manager.get_node(self.name)
	
	var dir : Directory = Directory.new()
	
	if dir.open(coreTypesDir) == OK:
		dir.list_dir_begin(true, true)
		var fileName = dir.get_next()
		while fileName != "":
			if not dir.current_is_dir():
				if fileName.get_extension() == "tres":
					var type : Resource = load(coreTypesDir + fileName)
					if "id" in type && type.id.empty():
						push_warning("ID for resource file at `" + coreTypesDir + fileName + "` is empty. This resource will not be loaded")
					else:
						types.append(type)
			fileName = dir.get_next()
	
	load_resources(coreMovesDir, "tscn", "move", "moves")
	
	load_resources(coreSensorsDir, "tscn", "sensor", "sensors")
	
	load_resources(coreEntitiesDir, "tscn", "entity", "entities")
	
	add_child(worlds[0].instance())
	for i in self.get_children():
		i.add_to_group("persist")
	
	add_to_group("persist")
	
	add_child(hud)

func load_resources(dirPath : String, extension : String, resourceId : String, resourceNamespace : String, namespace : String = "shockborn"):
	var dir : Directory = Directory.new()
	if dir.open(dirPath) == OK:
		dir.list_dir_begin(true, false)
		var fileName : String = dir.get_next()
		while fileName != "":
			var fullPath : String = dir.get_current_dir().plus_file(fileName)
			if dir.current_is_dir():
				load_resources(fullPath, extension, resourceId, resourceNamespace, namespace)
			elif fileName.get_extension() == extension:
				var packedScene : PackedScene = load(fullPath)
				var sceneState : SceneState = packedScene.get_state()
				for nodeID in sceneState.get_node_count():
					for propID in sceneState.get_node_property_count(nodeID):
						if sceneState.get_node_property_name(nodeID, propID) == resourceId + "Id":
							if sceneState.get_node_property_value(nodeID, propID) is String:
								if not resources.has(resourceNamespace):
									resources[resourceNamespace] = {}
								resources[resourceNamespace][namespace + ":" + sceneState.get_node_property_value(nodeID, propID)] = packedScene
			
			fileName = dir.get_next()
	else:
		push_warning("Could not open/find directory at `" + dirPath + "` while attempting to load: " + resourceNamespace)

func get_resource(id : String, resourceNamespace : String, namespace : String = "shockborn") -> PackedScene:
	return resources[resourceNamespace][namespace + ":" + id]

func spawn_entity(entityId : String, namespace : String = "shockborn", translation : Vector3 = Vector3.ZERO, rotation : Vector3 = Vector3.ZERO):
	var entity : Entity = get_resource(entityId, "entities", namespace).instance()
	entity.global_translation = translation
	entity.rotation = rotation

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		for i in Manager.menuManager.get_children():
			if(i.get_name() == "Pause"):
				return
		Manager.menuManager.load_menu(MenuManager.MENU.PAUSE)

func save():
	var saveNodes : Array = get_tree().get_nodes_in_group("persist")
	
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

func get_worlds(id : int) -> Node:
	return get_children()[id]
