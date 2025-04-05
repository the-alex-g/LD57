extends CharacterBody2D

@export var min_friction := 0.05
@export var max_friction := 1.0
@export var min_accel := 100.0
@export var max_accel := 200.0
@export var jump_radius := 50.0
@export var jump_accel := 50.0

var inertia := Vector2.ZERO
var _can_jump := true

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


func get_accel() -> float:
	return depth_lerp(max_accel, min_accel)


func get_friction() -> float:
	return depth_lerp(min_friction, max_friction)


func depth_lerp(min_val: float, max_val: float) -> float:
	return lerpf(min_val, max_val, get_depth())


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


func _draw() -> void:
	draw_circle(Vector2.ZERO, 8, Color.RED)
