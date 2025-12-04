extends Pickup
class_name ExpGem

## Experience gem that grants experience points to the player when collected

## Amount of experience this gem grants
@export var exp_value: int = 1


func apply_effect(player: Node2D) -> void:
	# Grant experience to the player
	if player.has_method("gain_experience"):
		player.gain_experience(exp_value)
