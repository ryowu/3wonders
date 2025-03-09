extends Area2D

@export var target_scene: String
@export var target_scene_key: String

func _on_body_entered(_body: Node2D) -> void:
	Central.set_stage_data(target_scene_key)
	TransitionScene.change_scene_fade("res://scenes/stages/" + target_scene + ".tscn")
