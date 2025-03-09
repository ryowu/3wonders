extends "res://scripts/chars/base_charactor.gd"
@onready var sound_sword_attack: AudioStreamPlayer2D = $player_sword_attack
@onready var weapon_attack_player: AnimationPlayer = $weapon_attack

func _ready() -> void:
	hp = 5
	hp_max = 5
	speed = 80
	jump_velocity = -238
	init_hp_bar()

func perform_attack(direction: float) -> void:
	sound_sword_attack.play()
	if(direction > 0):
		weapon_attack_player.play("sword_attack_right")
	elif(direction < 0):
		weapon_attack_player.play("sword_attack_left")
	if(direction != 0):	
		await weapon_attack_player.animation_finished
	# for area in sword.get_overlapping_areas():
	# 	if area.is_in_group("enemy"):
	# 		area.get_parent().enemy_hurt()
