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
var _game_over := false
var main_menu : Control
var _difficulty_scale := 0.0

@onready var _player := $Player
@onready var _tentacle_spawner := $TentacleSpawner


func _process(delta: float) -> void:
	if not _game_over:
		corruption -= _player.get_corruption_reduction() * delta


func _on_tentacle_spawner_increase_corruption(amount: float) -> void:
	corruption += amount


func _on_tentacle_spawner_increase_points(amount: float) -> void:
	points += amount


func _on_player_died() -> void:
	game_over.emit(false)


func _on_update_corruption(new_value: float) -> void:
	Music.update_corruption(new_value / max_corruption)


func _on_game_over(_win: bool) -> void:
	_game_over = true


func set_difficulty_scale(amount: float) -> void:
	_difficulty_scale = amount
	_tentacle_spawner.set_difficulty_scale(amount)


func set_player_outline_color(color: Color) -> void:
	_player.set_outline_color(color)


func _on_hud_return_to_main() -> void:
	get_tree().root.add_child(main_menu)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = main_menu


func _on_hud_restart() -> void:
	var new_game := preload("res://world/world.tscn").instantiate()
	new_game.main_menu = main_menu
	new_game.ready.connect(
		func():
			new_game.set_difficulty_scale(_difficulty_scale)
			new_game.set_player_outline_color(_player.outline_color)
	)
	
	get_tree().root.add_child(new_game)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = new_game
