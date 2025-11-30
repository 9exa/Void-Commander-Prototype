class_name UnitComp extends Node
## An entity that has health, a team, can die and other 'entity' metadata
signal died()


@export var max_heath: int = 100
@export var team: int = 0


const Teams {
	PLAYERS = 1,
	ENEMIES = 2,
}

var heath: int
