extends Node2D


var corruption := 0.0
var _was_corruption_set := false

@onready var _timer := $Timer
@onready var _particles := $CPUParticles2D


func _ready() -> void:
	_start_timer()
	_particles.one_shot = true


func _start_timer() -> void:
	_timer.start(lerpf(6.0, 10.0, randf()))


func _on_timer_timeout() -> void:
	_spawn_fish()
	_start_timer()


func _spawn_fish() -> void:
	if not _was_corruption_set:
		corruption = randf()
	_particles.color = Color(1.0 - corruption, 1.0 - corruption, 1.0 - corruption, 1.0)
	_particles.position.y = lerpf(10.0, 600.0, randf())
	_particles.amount = 10 + randi() % 11
	_particles.emitting = true


func _on_world_update_corruption(new_value: float) -> void:
	corruption = new_value / 100.0
	_was_corruption_set = true
