extends Area2D

@export var label_text: String = "Default Notice"
@onready var notice_panel: Panel = $Panel
@onready var notice_label: Label = $Panel/notice_label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	notice_panel.visible = false
	notice_label.text = label_text

func _on_body_entered(_body: Node2D) -> void:
	animation_player.play("fade_in")

func _on_body_exited(_body: Node2D) -> void:
	animation_player.play("fade_out")
