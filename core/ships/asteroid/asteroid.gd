class_name Asteroid extends Unit

## A drifting asteroid enemy that floats through space

## The asteroid's own drift velocity (independent of world_velocity)
@export var drift_velocity: Vector3 = Vector3.ZERO

## Area at which they collide with... stuff
@export var hitbox: Area3D

func _ready() -> void:
	# Set asteroid to enemy team
	team = 2  # Teams.ENEMIES

	# Initialize with full health
	health = max_health

func _physics_process(delta: float) -> void:
	# Apply drift velocity
	velocity = drift_velocity
	move_and_slide()
