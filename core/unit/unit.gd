class_name Unit extends CharacterBody3D

## An entity that has health, a team, can die and other 'entity' metadata
signal died()
signal spawned()


@export var max_health: int = 100
@export var team: int = 0
@export var movement: UnitMovementComp
# TODO: A whole ass Resource describing complex bounties
# Loot (amount of xp) dropped from killing it
@export var bounty: int
## Number of exp gems to drop when killed
@export var exp_drop_count: int = 1
## Experience value per gem dropped
@export var exp_per_gem: int = 1

const Teams {
	PLAYERS = 1,
	ENEMIES = 2,
}

var health: int

## Virtual functions

## Called when the unit is spawned
func _spawn() -> void:
	pass

## Called when the unit dies
func _die() -> void:
	_spawn_exp_gems()
	queue_free()

func _spawn_exp_gems() -> void:
	# Only spawn gems if we have a bounty configured
	if exp_drop_count <= 0 or exp_per_gem <= 0:
		return

	# Load the exp gem scene
	var exp_gem_scene = preload("res://core/pickups/exp_gem.gd")

	# Spawn the configured number of gems
	for i in range(exp_drop_count):
		var gem = ExpGem.new()
		gem.exp_value = exp_per_gem
		gem.global_position = global_position

		# Add to the same parent as this unit
		if get_parent():
			get_parent().add_child(gem)

func _take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		died.emit()
		_die()
