extends Control

signal return_to_main

@onready var _message_label := $Message


func _ready() -> void:
	hide()


func display(message: String) -> void:
	show()
	_message_label.text = message


func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://world/world.tscn")


func _on_main_menu_pressed() -> void:
	return_to_main.emit()
