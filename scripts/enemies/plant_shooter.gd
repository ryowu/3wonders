extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var enemy_hurt_audio: AudioStreamPlayer2D = $enemy_hurt_audio
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var shoot_timer: Timer = $ShootTimer
@onready var shoot_bean: AudioStreamPlayer2D = $shoot_bean

@export var direction = -1
@export var hp = 2

@export var death_particle: PackedScene
var coin_scene = preload("res://scenes/items/coin.tscn")
var bullet_scene = preload("res://scenes/items/plant_bullet.tscn")
var hurting = false
var dying = false

func _ready() -> void:
	shoot_timer.start()

func _on_shoot_timer_timeout() -> void:
	if !dying:
		shoot()

func shoot() -> void:
	var camera = get_viewport().get_camera_2d()
	var distance = global_position.distance_to(camera.get_screen_center_position())
	if distance < 500:
		shoot_bean.play()
	animated_sprite_2d.play("attack")

	await animated_sprite_2d.animation_finished
	animated_sprite_2d.play("idle")

	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		get_parent().add_child(bullet)
		bullet.position = position
		bullet.start_position = position
		bullet.set_direction(direction)

func _process(_delta: float) -> void:
	if hurting: return
	
	if direction > 0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false

func enemy_hurt() -> void:
	if hurting: return
	hurting = true
	hp -= 1
	enemy_hurt_audio.play()

	if hp <= 0:
		die()

	animated_sprite_2d.play("hurt")
	await animated_sprite_2d.animation_finished
	hurting = false
	animated_sprite_2d.play("idle")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.visible and area.is_in_group("player_weapon"):
		enemy_hurt()

func die() -> void:
	dying = true
	animated_sprite_2d.visible = false
	shoot_timer.stop()
	
	var _particle = death_particle.instantiate()
	_particle.position = global_position
	get_tree().current_scene.add_child(_particle)
	_particle.emitting = true

	# Defer coin spawning to avoid modifying physics state mid-query
	call_deferred("_spawn_coins")
	await enemy_hurt_audio.finished
	queue_free()

func _spawn_coins() -> void:
	var random_coin_amount = randi_range(1, 3)
	for i in range(random_coin_amount):
		var coin = coin_scene.instantiate()
		get_parent().add_child(coin) 
		coin.global_position = global_position


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !hurting and animated_sprite_2d.visible:
		body.hurt()
