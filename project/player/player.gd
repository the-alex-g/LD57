extends CharacterBody2D

@export var min_friction := 0.05
@export var max_friction := 1.0
@export var min_accel := 100.0
@export var max_accel := 200.0

var inertia := Vector2.ZERO

@onready var screen_height := DisplayServer.window_get_size().y


func _physics_process(delta: float) -> void:
	var input_direction := Input.get_vector(
		"left", "right", "up", "down"
	).normalized()
	
	inertia += input_direction * get_accel() * delta
	inertia -= inertia * get_friction() * delta
	
	move_and_collide(inertia * delta)


func get_accel() -> float:
	return depth_lerp(max_accel, min_accel)


func get_friction() -> float:
	return depth_lerp(min_friction, max_friction)


func depth_lerp(min_val: float, max_val: float) -> float:
	return lerpf(min_val, max_val, get_depth())


func get_depth() -> float:
	return global_position.y / screen_height
