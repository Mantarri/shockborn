extends Node

class_name State

var StateMachine : Node = null

func _ready():
	pass

# _unhandled_input virtual function
func _handle_input(_event : InputEvent) -> void:
	pass

# _process virtual function
func update(_delta : float) -> void:
	pass

func physics_update(_delta : float) -> void:
	pass

func enter(msg : = {}):
	pass

func exit() -> void:
	pass
