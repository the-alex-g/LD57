extends Control

signal return_to_main
signal restart

@onready var _message_label := $Message


func _ready() -> void:
	hide()


func display(message: String) -> void:
	show()
	_message_label.text = message


func _on_play_again_pressed() -> void:
	restart.emit()


func _on_main_menu_pressed() -> void:
	return_to_main.emit()
