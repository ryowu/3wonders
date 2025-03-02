extends Camera2D

var player : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player:
		global_position.x = player.global_position.x
		global_position.y = player.global_position.y - 85
