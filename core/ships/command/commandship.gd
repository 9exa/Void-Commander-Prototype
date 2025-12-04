class_name CommandShip extends Unit

## The ship that the player controls.

## Emitted when experience is gained
signal experience_gained(amount: int, total_exp: int)
## Emitted when player levels up
signal leveled_up(new_level: int)

@export_group("Progression")
@export var current_experience: int = 0
@export var current_level: int = 1
@export var experience_to_next_level: int = 100

# TODO: Create an entire ass ability system. But for now, have variables accosiated with each ability system here
@export_group("Abilities")
@export_subgroup("Tracter")
@export var target_reticle_cone: MeshInstance3D
@export var tracter_range: float
@export var tracter_radius: float
@export var max_tracter_energy: float
@export var tracter_energy: float
@export var tracter_energy_replenish_rate: float

func _point_at_location(target_position: Vector3) -> void:
	# Rotate the ship to face the target position
	var direction = (target_position - global_transform.origin).normalized()
	target_reticle_cone.look_at(target_position, Vector3.UP)


## Gain experience points and handle leveling up
func gain_experience(amount: int) -> void:
	current_experience += amount
	experience_gained.emit(amount, current_experience)

	# Check for level up
	while current_experience >= experience_to_next_level:
		_level_up()


func _level_up() -> void:
	current_experience -= experience_to_next_level
	current_level += 1

	# Scale experience requirement (simple 1.5x multiplier for now)
	experience_to_next_level = int(experience_to_next_level * 1.5)

	leveled_up.emit(current_level)
	print("Level up! Now level ", current_level)


