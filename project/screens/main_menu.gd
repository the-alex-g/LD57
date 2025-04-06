extends Control

var _player_outline_color := Color.BLACK : set = _set_player_outline_color

@onready var _player_image : TextureRect = $VBoxContainer3/VBoxContainer2/PlayerImage
@onready var _red_slider := $VBoxContainer3/VBoxContainer2/OutlineColorSliders/Red
@onready var _blue_slider := $VBoxContainer3/VBoxContainer2/OutlineColorSliders/Blue
@onready var _green_slider := $VBoxContainer3/VBoxContainer2/OutlineColorSliders/Green
@onready var _outline_color_sliders := $VBoxContainer3/VBoxContainer2/OutlineColorSliders
@onready var _difficulty_slider := $VBoxContainer3/VBoxContainer2/DifficultySlider


func _process(_delta: float) -> void:
	_player_outline_color.r = _red_slider.value / 255
	_player_outline_color.b = _blue_slider.value / 255
	_player_outline_color.g = _green_slider.value / 255


func _on_play_pressed() -> void:
	var game := preload("res://world/world.tscn").instantiate()
	
	game.ready.connect(
		func():
			game.set_difficulty_scale(_difficulty_slider.value / 100.0)
			game.set_player_outline_color(_player_outline_color)
			game.main_menu = self
	)
	get_tree().root.add_child(game)
	get_tree().current_scene = game
	get_tree().root.remove_child(self)


func _on_music_toggled(toggled_on: bool) -> void:
	Music.set_mute(not toggled_on)


func _set_player_outline_color(value: Color) -> void:
	_player_outline_color = value
	_player_image.material.set_shader_parameter("outline_color", value)


func _on_outline_toggled(toggled_on: bool) -> void:
	if toggled_on:
		_outline_color_sliders.show()
		_player_outline_color.a = 1.0
	else:
		_outline_color_sliders.hide()
		_player_outline_color.a = 0.0
