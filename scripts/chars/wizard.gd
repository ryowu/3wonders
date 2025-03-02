extends "res://scripts/chars/base_charactor.gd"
@onready var weapon_attack_player: AnimationPlayer = $weapon_attack
@onready var hammer_audio: AudioStreamPlayer2D = $hammer_audio

func _ready() -> void:
	hp = 3
	speed = 110
	jump_velocity = -300

func perform_attack(_direction: float) -> void:
	hammer_audio.play()
	weapon_attack_player.play("hammer_attack")
	await weapon_attack_player.animation_finished
	# for area in sword.get_overlapping_areas():
	# 	if area.is_in_group("enemy"):
	# 		area.get_parent().enemy_hurt()
