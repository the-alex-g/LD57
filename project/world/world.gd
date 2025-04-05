extends Node2D

signal update_corruption(new_value: float)
signal update_points(new_value: float)
signal game_over(win: bool)

@export var max_corruption := 100.0
@export var max_score := 100

var corruption := 0.0 :
	set(value):
		if value > 0.0:
			corruption = value
		else:
			corruption = 0.0
		update_corruption.emit(corruption)
		if corruption >= max_corruption:
			game_over.emit(false)
var points := 0.0 :
	set(value):
		points = value
		update_points.emit(points)
		if points >= max_score:
			game_over.emit(true)

@onready var _player := $Player


func _process(delta: float) -> void:
	corruption -= _player.get_corruption_reduction() * delta


func _on_tentacle_spawner_increase_corruption(amount: float) -> void:
	corruption += amount


func _on_tentacle_spawner_increase_points(amount: float) -> void:
	points += amount


func _on_player_died() -> void:
	game_over.emit(false)
