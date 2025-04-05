class_name Player
extends CharacterBody2D

signal update_health(new_value: int)

@export var min_friction := 0.05
@export var max_friction := 1.0
@export var min_accel := 100.0
@export var max_accel := 200.0
@export var min_heal_time := 1.0
@export var max_heal_time := 10.0
@export var min_corruption_reduction := 1.0
@export var max_corruption_reduction := 10.0
@export var jump_radius := 50.0
@export var jump_accel := 50.0

var inertia := Vector2.ZERO
var _heal_clock := 0.0
var _can_jump := true
var _health := 10 :
	set(value):
		if value > 10:
			_health = 10
		elif value < 0:
			_health = 0
		else:
			_health = value
		update_health.emit(_health)

@onready var screen_height := DisplayServer.window_get_size().y


func _physics_process(delta: float) -> void:
	var input_direction := Input.get_vector(
		"left", "right", "up", "down"
	).normalized()
	
	inertia += input_direction * get_accel() * delta
	inertia -= inertia * get_friction() * delta
	
	move_and_collide(inertia * delta)
	
	if _can_jump and Input.is_action_just_pressed("jump"):
		_jump()
	
	_heal_clock += delta
	if _heal_clock >= get_heal_time():
		_health += 1
		_heal_clock -= get_heal_time()


func get_corruption_reduction() -> float:
	return depth_lerp(min_corruption_reduction, max_corruption_reduction)


func get_heal_time() -> float:
	return depth_lerp(min_heal_time, max_heal_time)


func get_accel() -> float:
	return depth_lerp(max_accel, min_accel)


func get_friction() -> float:
	return depth_lerp(min_friction, max_friction)


func depth_lerp(a: float, b: float) -> float:
	return lerpf(a, b, get_depth())


func get_depth() -> float:
	return global_position.y / screen_height


func _jump() -> void:
	_can_jump = false
	
	var mouse_position := get_global_mouse_position()
	if mouse_position.distance_to(global_position) <= jump_radius:
		_jump_to(mouse_position)
	else:
		var jump_direction = (mouse_position - global_position).normalized()
		_jump_to(global_position + jump_direction * jump_radius, jump_direction)
	
	await get_tree().create_timer(2).timeout
	_can_jump = true


func _jump_to(pos: Vector2, direction := Vector2.ZERO) -> void:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, pos)
	query.collide_with_areas = true
	query.collide_with_bodies = false
	var result = space_state.intersect_ray(query)
	if result:
		if result.collider is TentacleSegment:
			result.collider.sever()
	
	if direction == Vector2.ZERO:
		direction = (pos - global_position).normalized()
	global_position = pos
	inertia += direction * jump_accel


func damage() -> void:
	_health -= 1
	_heal_clock = 0.0


func _draw() -> void:
	draw_circle(Vector2.ZERO, 8, Color.RED)
