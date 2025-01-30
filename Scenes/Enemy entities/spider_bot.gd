class_name SpiderBot_1
extends CharacterBody3D

@onready var wall_ray_cast_left = $Wall_Checks/Wall_RayCast_Left as RayCast3D
@onready var wall_ray_cast_right = $Wall_Checks/Wall_RayCast_Right as RayCast3D
@onready var floor_ray_cast_left = $Floor_Checks/Floor_Raycast_Left as RayCast3D
@onready var floor_ray_cast_right = $Floor_Checks/Floor_Raycast_Right as RayCast3D
@onready var player_track_raycast = $Player_Tracker_Pivot/Player_Track_Raycast as RayCast3D

@onready var player_tracker_pivot = $Player_Tracker_Pivot as Node3D

@onready var sprite_3d = $Sprite3D as Sprite3D
@onready var chase_timer = $Chase_Timer as Timer

@export var wander_speed : float = 2
@export var chase_speed : float = 4

var current_speed : float = 0.0
var player_found : bool = false

var player : CharacterBody3D = null

enum States {
	Wander,
	Chase
}

var current_state = States.Wander



func _ready() -> void:
	player_track_raycast.target_position = Vector3(1, 1, 1)  # No movement in Z
	player = get_tree().get_first_node_in_group("player") as CharacterBody3D
	if player == null:
		push_error("Player not found in the scene!")
	chase_timer.timeout.connect(on_timer_timeout)
	
func _physics_process(_delta):
	handle_vision()
	track_player()
	handle_movement()
	
	
	
func handle_movement() -> void:
	if player == null:
		return
	
	var direction = player.global_position - global_position  # Direction to player

	if current_state == States.Wander:
		# Check if the bot can move in either direction
		if not floor_ray_cast_right.is_colliding():
			current_speed = -wander_speed  # Move left
		elif not floor_ray_cast_left.is_colliding():
			current_speed = wander_speed   # Move right
		elif wall_ray_cast_right.is_colliding():
			current_speed = -wander_speed  # Change direction if hitting a wall
		elif wall_ray_cast_left.is_colliding():
			current_speed = wander_speed

		elif current_state == States.Chase:
			if player_found:
				if direction.x > 0:  # If player is to the right
					current_speed = chase_speed
			else:  # If player is to the left
				current_speed = -chase_speed
	
	velocity.x = current_speed
	move_and_slide()

	
func track_player():
	if player == null:
		return
	var direction_to_player : Vector3 = Vector3(player.position.x, player.position.y, player.position.z) - player_track_raycast.position
	
	player_tracker_pivot.look_at(direction_to_player)
	
	
func handle_vision():
	if player_track_raycast.is_colliding():
		var collision_result = player_track_raycast.get_collider()
		
		if collision_result != player:
			return
		else:
			current_state = States.Chase
			chase_timer.start(1)
			player_found = true
	
	else:
		player_found = false
		
		
	
	
	
func on_timer_timeout() -> void:
	if player_found == false:
		current_state = States.Wander
	
	
	
	
