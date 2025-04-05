extends CanvasLayer

@onready var _healthbar := $HBoxContainer/HealthBar
@onready var _corruption_bar := $HBoxContainer/CorruptionBar
@onready var _points_bar := $HBoxContainer/PointsBar
@onready var _end_of_game_screen := $EndOfGameScreen


func _on_player_update_health(new_value: int) -> void:
	_healthbar.interpolate_value(new_value, 0.5)


func _on_world_update_corruption(new_value: float) -> void:
	_corruption_bar.value = new_value


func _on_world_update_points(new_value: float) -> void:
	_points_bar.interpolate_value(new_value, 0.5)


func _on_world_game_over(win: bool) -> void:
	_end_of_game_screen.display(
		"You win!" if win else "You lose."
	)
