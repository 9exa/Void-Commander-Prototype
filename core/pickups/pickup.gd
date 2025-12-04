extends Area2D
class_name Pickup

## Base class for all collectible pickups
## Handles magnetic pull toward attraction sources and collision detection

## Distance at which the pickup starts moving toward attraction sources
@export var magnetic_range: float = 100.0

## Speed at which the pickup moves when magnetically pulled
@export var pull_speed: float = 300.0

## Emitted when this pickup is collected
signal picked_up(pickup: Pickup)

var _attraction_sources: Array[Node2D] = []
var _is_being_pulled: bool = false


func _ready() -> void:
	# Set up collision layers (adjust these based on your project's layer setup)
	collision_layer = 8  # Pickup layer
	collision_mask = 2   # Player layer

	# Connect to body entered signal
	body_entered.connect(_on_body_entered)

	# Find attraction sources
	_find_attraction_sources()


func _physics_process(delta: float) -> void:
	if _attraction_sources.is_empty():
		_find_attraction_sources()
		return

	# Find the closest valid attraction source
	var closest_source: Node2D = null
	var closest_distance := INF

	for source in _attraction_sources:
		if not is_instance_valid(source):
			continue

		var distance := global_position.distance_to(source.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_source = source

	# Apply magnetic pull if within range
	if closest_source and closest_distance <= magnetic_range:
		_is_being_pulled = true
		var direction := global_position.direction_to(closest_source.global_position)
		global_position += direction * pull_speed * delta
	else:
		_is_being_pulled = false


func _find_attraction_sources() -> void:
	# For now, just find the player
	# In the future, this could include other attraction sources
	_attraction_sources.clear()

	var players := get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		_attraction_sources.append(players[0])


func _on_body_entered(body: Node2D) -> void:
	# Check if the body that entered is the player
	if body.is_in_group("player"):
		apply_effect(body)
		picked_up.emit(self)
		queue_free()


## Virtual method to be overridden by subclasses
## Apply the pickup's effect to the player
func apply_effect(player: Node2D) -> void:
	pass  # Override in subclasses
