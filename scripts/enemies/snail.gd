extends Node2D

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var enemy_hurt_audio: AudioStreamPlayer2D = $enemy_hurt_audio
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

@export var SPEED = 10
@export var direction = -1
@export var hp = 2

@export var death_particle: PackedScene
var coin_scene = preload("res://scenes/items/coin.tscn")
var hurting = false

func _process(delta: float) -> void:
	if hurting: return
	
	if direction > 0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	
	if ray_cast_right.is_colliding():
		direction = -1
	if ray_cast_left.is_colliding():
		direction = 1
	position.x += SPEED * delta * direction


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
	animated_sprite_2d.play("run")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.visible and area.is_in_group("player_weapon"):
		enemy_hurt()
		
func die() -> void:
	animated_sprite_2d.visible = false
	
	var _particle = death_particle.instantiate()
	_particle.position = global_position
	get_tree().current_scene.add_child(_particle)
	_particle.emitting = true

	# Defer coin spawning to avoid modifying physics state mid-query
	call_deferred("_spawn_coins")
	await enemy_hurt_audio.finished
	queue_free()

# This function is called later, outside the physics processing step
func _spawn_coins() -> void:
	var random_coin_amount = randi_range(1, 2)
	for i in range(random_coin_amount):
		var coin = coin_scene.instantiate()
		get_parent().add_child(coin) 
		coin.global_position = global_position


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !hurting and animated_sprite_2d.visible:
		body.hurt()
