class_name UnitMovementComp extends Node
# Describes how a unit moves around the world

@abstract func _movement(delta: float) -> void:
	# Implement movement logic here
	pass

func _process(delta: float) -> void:
	_movement(delta)
