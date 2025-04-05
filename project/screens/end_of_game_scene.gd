extends Control

@onready var _message_label := $Message


func _ready() -> void:
	hide()


func display(message: String) -> void:
	show()
	_message_label.text = message


func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://world/world.tscn")
