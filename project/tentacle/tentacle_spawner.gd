extends Node2D

signal increase_corruption(amount: float)

@onready var _path_follow := $Path2D/PathFollow2D
@onready var _tentacle_container := $TentacleContainer


func _on_spawn_timer_timeout() -> void:
	_spawn_tentacle()


func _spawn_tentacle() -> void:
	var tentacle := preload("res://tentacle/tentacle.tscn").instantiate()
	_path_follow.progress_ratio = 1.0 - pow(randf(), 2.0)
	_tentacle_container.add_child(tentacle)
	tentacle.transform = _path_follow.transform
	tentacle.build_tentacle(6 + randi() % 5)


func _process(delta: float) -> void:
	var corruption := 0.0
	for tentacle in _tentacle_container.get_children():
		corruption += tentacle.length
	increase_corruption.emit(corruption * delta)
