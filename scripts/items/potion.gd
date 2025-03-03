extends Sprite2D

@onready var drink: AudioStreamPlayer2D = $drink

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.recover(5)
		drink.play()
		queue_free()
