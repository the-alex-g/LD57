extends CanvasLayer

@onready var _healthbar := $HBoxContainer/HealthBar
@onready var _corruption_bar := $HBoxContainer/CorruptionBar
@onready var _points_bar := $HBoxContainer/PointsBar


func _on_player_update_health(new_value: int) -> void:
	_healthbar.value = new_value


func _on_world_update_corruption(new_value: float) -> void:
	_corruption_bar.value = new_value


func _on_world_update_points(new_value: float) -> void:
	_points_bar.value = new_value
