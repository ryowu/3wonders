extends Node2D

@export var speed = 150
var direction = 1
var start_position: Vector2

func _process(delta: float) -> void:
	position.x += speed * direction * delta
	
	if position.distance_to(start_position) > 300:
		queue_free()

func set_direction(dir: int) -> void:
	direction = dir

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.hurt()
		queue_free()
