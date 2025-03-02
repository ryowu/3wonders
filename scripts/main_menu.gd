extends Control
@onready var start_game: Button = $MarginContainer/VBoxContainer/start_game
@onready var exit_game: Button = $MarginContainer/VBoxContainer/exit_game
@onready var button_switch: AudioStreamPlayer2D = $button_switch
@onready var button_pressed: AudioStreamPlayer2D = $button_pressed

var loading = true
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	start_game.grab_focus()
	loading = false
	MusicPlayer.stream = load("res://assets/music/main_op1.mp3")
	MusicPlayer.play()

func _on_button_pressed() -> void:
	start_game.release_focus()
	button_switch.stop()
	button_pressed.play()
	await button_pressed.finished
	MusicPlayer.stop()
	#MusicPlayer.stream = load("res://assets/music/stage1.mp3")
	#MusicPlayer.volume_db = -10
	#MusicPlayer.play()
	TransitionScene.change_scene("res://scenes/stages/stage1.tscn")

func _on_exit_game_pressed() -> void:
	get_tree().quit()

func _on_start_game_focus_entered() -> void:
	if loading: return
	button_switch.stop()
	button_switch.play()

func _on_exit_game_focus_entered() -> void:
	button_switch.stop()
	button_switch.play()
