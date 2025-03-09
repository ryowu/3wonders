extends Node
# Define an enum for direction
enum Direction { LEFT, RIGHT }

var coin_amount: int = 0
var current_stage_position := { "position":Vector2.ZERO, "direction":Direction.LEFT}

# Dictionary with key-value pairs, where the value is an object containing position and direction
var stage_positions: Dictionary = {
	"stage_1_1": { "position": Vector2(100, 200), "direction": Direction.LEFT },
	"stage_1_2": { "position": Vector2(2250, 0), "direction": Direction.LEFT },
	"stage_2_1": { "position": Vector2(20, 0), "direction": Direction.RIGHT }
}

func add_coin(amount: int = 1) -> void:
	coin_amount += amount

func set_stage_data(stage_name: String) -> void:
	current_stage_position = stage_positions.get(stage_name, { "position": Vector2.ZERO, "direction": Direction.LEFT })
