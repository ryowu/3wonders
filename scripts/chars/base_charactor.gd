extends CharacterBody2D

var hurting := false
var attacking := false
var freezing := false
var direction_in_freeze: float = 0
var direction_current: float = 1
var dying := false

var hp := 10
var speed := 110.0
var jump_velocity := -300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player_hurt: AudioStreamPlayer2D = $player_hurt
@onready var player_jump: AudioStreamPlayer2D = $player_jump
@onready var player_die: AudioStreamPlayer2D = $player_die

var hp_bar: ProgressBar

func _physics_process(delta: float) -> void:
	if is_dying():
		return

	apply_gravity(delta)

	handle_jump()

	var direction := Input.get_axis("move_left", "move_right")
	if (direction != 0):
		direction_current = direction
	if !is_freezing() and !is_attacking() and Input.is_action_just_pressed("attack"):
		attack(direction_current)
	
	if !is_freezing() and !is_attacking():
		handle_movement_and_flip(direction)

	handle_movement(direction)
	move_and_slide()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func handle_jump() -> void:
	if !is_freezing() and Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		# player_jump.play()

func handle_movement_and_flip(direction: float) -> void:
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	if is_on_floor():
		animated_sprite.play("idle" if direction == 0 else "run")
	else:
		animated_sprite.play("jump")

func handle_movement(direction: float) -> void:
	if is_freezing():
		velocity.x = - direction_in_freeze * speed * 0.2
	else:
		direction_in_freeze = direction
		velocity.x = direction * speed if direction else move_toward(velocity.x, 0, speed)

func attack(direction: float) -> void:
	attacking = true
	await perform_attack(direction)
	attacking = false

func perform_attack(_direction: float) -> void:
	# To be overridden by child classes (Knight, Wizard, etc.)
	pass

func link_hp_bar(bar: ProgressBar) -> void:
	if bar:
		hp_bar = bar

func init_hp_bar() -> void:
	if hp_bar:
		hp_bar.min_value = 0
		hp_bar.max_value = hp
		hp_bar.value = hp

func hurt() -> void:
	if hurting or is_freezing() or is_dying():
		return
	hurting = true
	hp -= 1

	# Update the health bar
	if hp_bar:
		print(hp)
		hp_bar.value = hp

	if hp <= 0:
		die()
		return

	player_hurt.play()
	apply_damage_effect()

func apply_damage_effect() -> void:
	freezing = true
	animated_sprite.play("hurt")
	animated_sprite.modulate = Color(1, 1, 1, 0.5)
	await get_tree().create_timer(0.5).timeout
	freezing = false
	await get_tree().create_timer(1.0).timeout
	animated_sprite.modulate = Color(1, 1, 1, 1)
	hurting = false

func die() -> void:
	if is_dying():
		return
	dying = true
	player_die.play()
	animated_sprite.play("die")
	await animated_sprite.animation_finished
	await get_tree().create_timer(1.8).timeout
	TransitionScene.change_scene("res://scenes/stages/stage1.tscn")

# Utility functions for better readability
func is_dying() -> bool:
	return dying

func is_attacking() -> bool:
	return attacking

func is_freezing() -> bool:
	return freezing

func pickup_coin() -> void:
	Central.add_coin()
	var base_stage = get_tree().current_scene
	base_stage.update_coin_amount()
