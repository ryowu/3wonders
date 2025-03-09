extends "res://scripts/stages/base_stage.gd"

func _ready() -> void:
	super._ready()
	
	knight_instance.position = Central.current_stage_position.position
	
	if Central.current_stage_position.direction == Central.Direction.LEFT:
		knight_instance.get_node("AnimatedSprite2D").flip_h = true
