extends Node

class_name StateManager

export(NodePath) var initialState

signal transitioned(StateName)

onready var state : State

func _ready() -> void:
	yield(owner, "ready")
	for child in get_children():
		child.StateMachine = self
	state.enter()

# _unhandled_input virtual function
func _unhandled_input(event : InputEvent) -> void:
	state._handle_input(event)

# _process virtual function
func _process(delta : float) -> void:
	state.update(delta)

func _physics_process(delta : float) -> void:
	state.physics_update(delta)

func change_to(stateName : String, msg : Dictionary = {}) -> void:
	if(!has_node(stateName)):
		return
	
	state.exit()
	state = get_node(stateName)
	state.enter(msg)
	emit_signal("transitioned", state.name)
