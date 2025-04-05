extends Node2D

signal update_corruption(new_value: float)

@onready var _player := $Player


var corruption := 0.0 :
	set(value):
		if value > 0.0:
			corruption = value
		else:
			corruption = 0.0
		update_corruption.emit(corruption)


func _process(delta: float) -> void:
	corruption -= _player.get_corruption_reduction() * delta


func _on_tentacle_spawner_increase_corruption(amount: float) -> void:
	corruption += amount
