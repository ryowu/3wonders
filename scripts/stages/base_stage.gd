extends Node2D

@onready var camera_2d: Camera2D = $Camera2D
@onready var knight_hp_bar: ProgressBar = $CanvasLayer/bars/knight_hp_bar
@onready var coin_amount: Label = $CanvasLayer/bars/coin_amount
var knight_scene: PackedScene = preload("res://scenes/chars/knight.tscn")
var wizard_scene: PackedScene = preload("res://scenes/chars/wizard.tscn")
var gunner_scene: PackedScene = preload("res://scenes/chars/gunner.tscn")

var knight_instance
var wizard_instance
var gunner_instance
var current_character # Tracks the active character
var character_list = [] # List to hold all characters
var character_index = 0 # Tracks which character is active

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	# Instantiate characters
	knight_instance = knight_scene.instantiate()
	wizard_instance = wizard_scene.instantiate()
	gunner_instance = gunner_scene.instantiate()

	# Set Z index (correct property name)
	knight_instance.z_index = 5
	wizard_instance.z_index = 5
	gunner_instance.z_index = 5

	# Add them to the list
	character_list.append(knight_instance)
	character_list.append(wizard_instance)
	character_list.append(gunner_instance)

	# Link health bar to the character
	knight_instance.link_hp_bar(knight_hp_bar)

	# Add characters to the scene and disable non-active ones
	add_child(knight_instance)
	add_child(wizard_instance)
	add_child(gunner_instance)

	disable_character(wizard_instance)
	disable_character(gunner_instance)

	# Start with the knight as the default character
	current_character = knight_instance
	knight_instance.position.x = 96
	switch_character(knight_instance)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		TransitionScene.change_scene_fade("res://scenes/misc/main_menu.tscn")
		return

	if event.is_action_pressed("LeftShift"):
		# Cycle to the next character
		character_index = (character_index + 1) % character_list.size()
		switch_character(character_list[character_index])

func switch_character(new_character) -> void:
	# Disable the current character
	disable_character(current_character)

	# Get the AnimatedSprite2D node from both characters
	var old_sprite = current_character.get_node("AnimatedSprite2D")
	var new_sprite = new_character.get_node("AnimatedSprite2D")

	# Copy position and facing direction
	new_character.position = current_character.position
	new_sprite.flip_h = old_sprite.flip_h # Preserve facing direction

	# Enable the new character
	enable_character(new_character)

	# Set the new character as active
	current_character = new_character
	camera_2d.player = current_character

func disable_character(character):
	character.visible = false
	character.set_physics_process(false)
	character.set_process(false)
	
	# Disable all CollisionShape2D nodes inside the character
	for child in character.get_children():
		if child is CollisionShape2D:
			child.disabled = true

func enable_character(character):
	character.visible = true
	character.set_physics_process(true)
	character.set_process(true)

	# Enable all CollisionShape2D nodes inside the character
	for child in character.get_children():
		if child is CollisionShape2D:
			child.disabled = false

func update_coin_amount() -> void:
	coin_amount.text = str(Central.coin_amount)
