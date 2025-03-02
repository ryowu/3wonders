extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var gravity = 980  # Gravity strength
var friction = 0.8  # Friction to slow down horizontal movement

func _ready():
	# Give the coin an initial random "fly out" velocity
	var random_direction = Vector2(randf_range(-1, 1), randf_range(-1, -0.5)).normalized()
	var speed = randf_range(100, 250)  # Adjust speed as needed
	velocity = random_direction * speed  # Set velocity instead of impulse

func _physics_process(delta):
	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.x *= friction  # Apply friction to slow down horizontal movement

		# Stop completely if velocity is very small
		if abs(velocity.x) < 1:
			velocity.x = 0  

	move_and_slide()  # Move the coin using velocity

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if _body.is_in_group("player"):
		_body.pickup_coin()
		animation_player.play("pickup")
