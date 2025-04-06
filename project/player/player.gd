class_name Player
extends CharacterBody2D

signal update_health(new_value: int)
signal died

@export_group("Depth Variables")
@export var min_friction := 0.1
@export var max_friction := 2.0
@export var min_accel := 150.0
@export var max_accel := 300.0
@export var min_heal_time := 1.0
@export var max_heal_time := 100.0
@export var min_corruption_reduction := 3.0
@export var max_corruption_reduction := 15.0
@export_group("Jumping")
@export var jump_radius := 50.0
@export var jump_accel := 50.0
@export var jump_cooldown := 0.75

var _heal_clock := 0.0
var _can_jump := true
var _game_over := false
var _health := 5 :
	set(value):
		if value > 5:
			_health = 5
		elif value <= 0:
			if _health != 0:
				died.emit()
			_health = 0
		else:
			_health = value
		update_health.emit(_health)

@onready var screen_height := DisplayServer.window_get_size().y
@onready var _jump_cursor := $Sprite2D


func _physics_process(delta: float) -> void:
	var input_direction := Vector2.ZERO
	if not _game_over:
		input_direction = Input.get_vector(
			"left", "right", "up", "down"
		).normalized()
	
		if _can_jump and Input.is_action_just_pressed("jump"):
			_jump()
	
	if _can_jump and not _game_over:
		_jump_cursor.global_position = _get_jump_position()
		_jump_cursor.show()
	else:
		_jump_cursor.hide()
	
	velocity += input_direction * get_accel() * delta
	velocity -= velocity * get_friction() * delta
	
	move_and_slide()
	
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
	
	_jump_to(_get_jump_position())
	
	await get_tree().create_timer(jump_cooldown).timeout
	_can_jump = true


func _jump_to(pos: Vector2) -> void:
	pos = _check_for_walls(pos)
	
	_check_for_tentacles(pos)
	
	var direction := (pos - global_position).normalized()
	global_position = pos
	velocity += direction * jump_accel


func _get_jump_position() -> Vector2:
	var mouse_position := get_global_mouse_position()
	if mouse_position.distance_to(global_position) <= jump_radius:
		return mouse_position
	else:
		var jump_direction = (mouse_position - global_position).normalized()
		return global_position + jump_direction * jump_radius


func _check_for_walls(target: Vector2) -> Vector2:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, target)
	query.collide_with_bodies = true
	query.exclude = [get_rid()]
	
	var result := space_state.intersect_ray(query)
	if result:
		return result.position
	else:
		return target


func _check_for_tentacles(target: Vector2, to_ignore := []) -> void:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, target)
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.exclude = to_ignore
	
	var result := space_state.intersect_ray(query)
	if result and result.collider is TentacleSegment:
		result.collider.sever()
		
		to_ignore.append(result.collider.get_rid())
		_check_for_tentacles(target, to_ignore)


func damage() -> void:
	_health -= 1
	_heal_clock = 0.0


func _draw() -> void:
	draw_circle(Vector2.ZERO, 8, Color.RED)


func _on_world_game_over(win: bool) -> void:
	if not win:
		_game_over = true
		_jump_cursor.hide()
