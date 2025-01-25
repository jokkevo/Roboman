extends CharacterBody3D

@export var SPEED = 3.0
@export var JUMP_VELOCITY = 4.5
@export var acceleration = 12.0
@export var deceleration = 10.0
@export var gravity_multiplier = 1.0  # Multiplier for gravity

@export var attacking = false


@onready var animation:  = $AnimationPlayer
@onready var sprite_3d = $Sprite3D

# Connect the animation_finished signal to reset 'attacking' flag when attack animation finishes


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		attack()

func _physics_process(delta: float) -> void:
	# Modify gravity multiplier based on player state
	if not is_on_floor():
		if velocity.y > 0:  # Ascending (jumping up)
			gravity_multiplier = 1.0  # Normal gravity
		else:  # Descending (falling down)
			gravity_multiplier = 2.0  # Increased gravity

		velocity += get_gravity() * gravity_multiplier * delta

	else:
		gravity_multiplier = 1.0  # Reset gravity when on the floor
	
	# Handle jump release for short hop
	if Input.is_action_just_released("jump") and velocity.y > 0:
		velocity.y *= 0.5
	
			
	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get input for horizontal movement
	var input_dir = Input.get_vector("left","right", "ui_up", "ui_down")
	
	#Constrain the movement to X and Y vectors
	var move_dir = Vector3(input_dir.x, 0, input_dir.y)
	
	velocity.x = move_toward(velocity.x, move_dir.x * SPEED, acceleration * delta)

	
	if input_dir.x > 0:
		$Sprite3D.scale.x = 1
	elif input_dir.x < 0:
		$Sprite3D.scale.x = -1
		
	
	#Decelerate when no input is given
	if move_dir == Vector3.ZERO:
		velocity.x = move_toward(velocity.x, input_dir.x * SPEED, acceleration * delta)
			

	

	# Move the character
	move_and_slide()

	# Handle animations
	update_animation(Vector3(input_dir.x, 0, 0))

func attack():
	attacking = true
	animation.play("attack_1")
	# Set a timer or use an nimation callback to reset attacking flag after attacj animation finishes

func update_animation(_direction: Vector3) -> void:
	if !attacking:
		if velocity.y > 0:  # Ascending
			animation.play("jump")
		elif velocity.y < 0 and not is_on_floor():  # Descending
			animation.play("Fall")
		if velocity.x != 0 and is_on_floor():
			animation.play("run")  # Optional fall animation
		elif velocity.x == 0 and is_on_floor():
			animation.play("idle")	
	else:  # Idle
		animation.play("attack_1")
