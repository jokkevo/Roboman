extends CharacterBody3D

@export var speed = 5.0

func _physics_process(_delta: float) -> void:
	# Initialize movement direction
	

	# Get input for movement
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.z -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.z += 1

	# Normalize direction and apply speed
	velocity = velocity.normalized() * speed

	# Move the character
