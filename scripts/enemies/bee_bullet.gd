extends Node2D

@export var speed = 170
var start_position: Vector2

func _process(delta: float) -> void:
	position.y += speed * delta
	
	if position.distance_to(start_position) > 120:
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.hurt()
		queue_free()
