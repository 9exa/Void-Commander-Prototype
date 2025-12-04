class_name Level extends Node

# The linear motion of the world relative to the player
@export var world_velocity: Vector3

## Distance at which any entity despawns
const DESPAWN_DISTANCE: float = 1000.0


# TODO: A more robust way of describing enemy spawns
@export_group("Enemies")
@export_subgroup("Asteroid")
## Chance an asteroid will spawn every second
@export var asteroid_spawn_rate: float
## Lenght of the line on which asteroids
@export var asteroid_spawn_boundary_width: float
## Distance of the line that asteraoids spawn from the player
@export var asteroid_spawn_boundary_distance: float
## Asteroid scene to spawn
@export var asteroid_scene: PackedScene
## Maximum health for spawned asteroids
@export var asteroid_max_health: int = 100
## Maximum drift speed for asteroids
@export var asteroid_max_drift_speed: float = 2.0

@export_subgroup("Node references")
@export var player_ship: CommandShip
@export var enemy_container: Node

# Internal spawn timer
var _asteroid_spawn_accumulator: float = 0.0


func _spawn_enemies() -> void:
	pass

func _process(delta: float) -> void:
	_spawn_asteroids(delta)
	_apply_world_velocity(delta)
	_despawn_distant_enemies()


func _spawn_asteroids(delta: float) -> void:
	if not asteroid_scene or not enemy_container or not player_ship:
		return

	# Accumulate spawn probability
	_asteroid_spawn_accumulator += asteroid_spawn_rate * delta

	# Check if we should spawn (probabilistic spawning)
	while _asteroid_spawn_accumulator >= 1.0:
		_asteroid_spawn_accumulator -= 1.0
		_spawn_single_asteroid()


func _spawn_single_asteroid() -> void:
	# Instantiate asteroid
	var asteroid: Asteroid = asteroid_scene.instantiate()

	# Calculate spawn position
	# Spawn along a line perpendicular to world_velocity direction
	var spawn_direction = world_velocity.normalized()
	var perpendicular = Vector3.UP.cross(spawn_direction).normalized()

	# Random position along the boundary line
	var boundary_offset = randf_range(-asteroid_spawn_boundary_width / 2.0, asteroid_spawn_boundary_width / 2.0)
	var spawn_position = player_ship.global_position + (spawn_direction * asteroid_spawn_boundary_distance) + (perpendicular * boundary_offset)

	asteroid.global_position = spawn_position

	# Set asteroid properties
	asteroid.max_health = asteroid_max_health
	asteroid.health = asteroid_max_health
	asteroid.team = 2  # ENEMIES

	# Give asteroid a small random drift velocity
	var drift_direction = Vector3(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()
	asteroid.drift_velocity = drift_direction * randf_range(0.0, asteroid_max_drift_speed)

	# Add to scene
	enemy_container.add_child(asteroid)


func _apply_world_velocity(delta: float) -> void:
	if not enemy_container:
		return

	# Apply world velocity to all enemies
	for child in enemy_container.get_children():
		if child is CharacterBody3D:
			child.global_position -= world_velocity * delta


func _despawn_distant_enemies() -> void:
	if not enemy_container or not player_ship:
		return

	# Check all enemies and despawn those too far away
	for child in enemy_container.get_children():
		if child is Node3D:
			var distance = child.global_position.distance_to(player_ship.global_position)
			if distance > DESPAWN_DISTANCE:
				child.queue_free()

